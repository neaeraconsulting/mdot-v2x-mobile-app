import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/mqtt/mqtt_agent.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:get/get.dart';

class Pc5MqttAgent extends MqttAgent{

  SettingsController settingsController = Get.find<SettingsController>();
  Pc5MqttAgent(Function(String?, String, List<int>, DateTime, DateTime?, String) processingFunction): super("PC5", processingFunction);

  @override
  Future<int> connect() async{
    connectionUrl = settingsController.pc5BrokerUrl.value;
    int result = await mqttService.connect(settingsController.pc5BrokerUrl.value, null);
    return result;
  }

  @override
  Future<int> setupSubscribers() async{
    print("Subscribing to PC5 Topics");
    mqttService.subscribe("Ettifos/V2X/ind/J2735/#", callback);
    return 0;
  }

  @override 
  String sendMessage(List<int> message, MsgType messageType, DateTime sendTime){
    return "";
  }

  @override
  Future<int> updateSubscribers() async{
    return 0;
  }
}