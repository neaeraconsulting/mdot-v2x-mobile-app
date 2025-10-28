import 'package:cv_mec/controllers/configuration_controller.dart';
import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/etx/full_registration.dart';
import 'package:cv_mec/models/etx/registration.dart';
import 'package:cv_mec/models/mqtt/mqtt_agent.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:cv_mec/models/utils.dart';
import 'package:cv_mec/services/api_service.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:cv_mec/services/timing.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_data.dart';
import 'package:cv_mec/models/protobuf_models/geo_routed_msg.pb.dart' as protobuf;

class EtxMqttAgent extends MqttAgent{

  ApiService apiService = Get.find<ApiService>();
  FileService fileService = Get.find<FileService>();
  ParamController paramController = Get.find<ParamController>();
  SettingsController settingsController = Get.find<SettingsController>();
  ConfigurationController configController = Get.find<ConfigurationController>();
  Timing timingService = Get.find<Timing>();
  ASNService asnService = Get.find<ASNService>();
  
  FullRegistration? fullRegistration;

  EtxMqttAgent(Function(String?, String, List<int>, DateTime, DateTime?, String) processingFunction): super("ETX", processingFunction);

  @override
  Future<int> connect() async{
    String? token = await apiService.getToken();
    if (token == null) {
      logger.w("Unable to retrieve token from partner API. Please verify partner API credentials in settings menu");
      return 1;
    }

    Registration? registration;

    if (await fileService.checkIfRegistrationExists()) {
      logger.i("Loading Registration from Cache");
      registration = await fileService.getRegistration();
      fullRegistration = await apiService.checkRegistration(token, registration.deviceID);
      
    }

    if(registration == null || fullRegistration == null){
      logger.i("Loading Registration from Partner API");
      registration = await apiService.getRegistration(token, paramController.clientType.value, paramController.clientSubtype.value);
      fullRegistration = await apiService.checkRegistration(token, registration!.deviceID);
    }
    
    if(fullRegistration != null){
      fileService.saveRegistration(registration);
    }else{
      logger.w("Unable to retrieve full registration information from partner API");
      return 2;
    }



    logger.i("Acquired Certificates for DeviceID: ${fullRegistration!.deviceID}");


    String vzString = paramController.networkType.value;

    if (settingsController.vzMode.value) {
      vzString = "VZ";
    } else {
      vzString = "non-VZ";
    }

    if(paramController.manualRegistrationMode.value || currentPosition == null){
      connectionUrl = await apiService.getConnection(token, fullRegistration!.deviceID,
        paramController.registrationLatitude.value, paramController.registrationLongitude.value, vzString);
    }else{
      connectionUrl = await apiService.getConnection(token, fullRegistration!.deviceID,
        currentPosition!.latitude, currentPosition!.longitude, vzString);
    }
    
    int result = await mqttService.connect(connectionUrl!, registration);
    if (result != 0) {
      return 3;
    }

    return 0;
  }

  @override
  Future<int> setupSubscribers() async{
    mqttService.subscribe("vzimp/1/Private/+/+/+/j2735/+/+", onRawAsnMessage); //MAP / TIM
    mqttService.subscribe("vzimp/1/Private/+/+/+/j2735_gr/+/+", onGeoRelevanceMessage);
    mqttService.subscribe("vzimp/1/GeoRelevance/+/+/Public/j2735/+/+", onRawAsnMessage); // SPaT
    mqttService.subscribe("vzimp/1/GeoRelevance/+/+/Public/j2735_gr/+/+", onGeoRelevanceMessage);
    return 0;
  }

  @override 
  String sendMessage(List<int> message, MsgType messageType, DateTime sendTime){

    protobuf.GeoRoutedMsg msg = protobuf.GeoRoutedMsg();
    protobuf.Position pos = protobuf.Position();

    if(currentPosition != null){
      pos.latitude = currentPosition!.latitude;
      pos.longitude = currentPosition!.longitude;
    }else{
      return "Failure to Send Message - No Position";
    }

    msg.position = pos;

    Uint8Buffer buffer = Uint8Buffer();

    if(settingsController.enableIssScmsSigning.value){
      String? trimmedMessage;
      if(messageType == MsgType.BSM){
        trimmedMessage = asnService.trimMessageHeaders(ASNService.bytesToHex(message), asnService.BSM_START_FLAG);
      }else if(messageType == MsgType.PSM){
        trimmedMessage = asnService.trimMessageHeaders(ASNService.bytesToHex(message), asnService.BSM_START_FLAG);
      }
      
      if(trimmedMessage != null){
        message = ASNService.hexToBytes(trimmedMessage);
      }
    }
    

    msg.msgBytes = message;
    msg.time = Utils.dateTimeToTimestamp(sendTime);
      
    buffer.addAll(msg.writeToBuffer());

    String clientType = paramController.clientType.value;
    String clientSubtype = paramController.clientSubtype.value;
    if(fullRegistration != null){
      clientType = fullRegistration!.clientType;
      clientSubtype = fullRegistration!.clientSubtype;
    }

    String topic = "";
    switch (messageType) {
      case MsgType.BSM:
        topic = "vzimp/1/GeoRelevance/$clientType/$clientSubtype/Public/${paramController.messageFormat}/BSM";
        break;
      case MsgType.PSM:
        topic = "vzimp/1/GeoRelevance/$clientType/$clientSubtype/Public/${paramController.messageFormat}/PSM";
        break;
      default:
        logger.e('$agentName does not support sending ${messageType.name} messages');
        break;
    }
    mqttService.publishBytes(buffer, topic);
    return topic;
  }

  void onGeoRelevanceMessage(MqttReceivedMessage<MqttMessage?> message, DateTime recTime) async {
    final recMess = message.payload as MqttPublishMessage;
    protobuf.GeoRoutedMsg decodedMessage = protobuf.GeoRoutedMsg.fromBuffer(recMess.payload.message);
    DateTime msgTime = Utils.timeStampToDateTime(decodedMessage.time);
    processingFunction(connectionUrl, message.topic, decodedMessage.msgBytes, recTime, msgTime, "ETX");
  }

  void onRawAsnMessage(MqttReceivedMessage<MqttMessage?> message, DateTime recTime) async {
    final recMess = message.payload as MqttPublishMessage;
    processingFunction(connectionUrl, message.topic, recMess.payload.message, recTime, null, "ETX");
  }
}

