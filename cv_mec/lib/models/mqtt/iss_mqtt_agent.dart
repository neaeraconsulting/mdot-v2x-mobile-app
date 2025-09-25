import 'package:cv_mec/models/mqtt/mqtt_agent.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:typed_data/typed_data.dart';

class IssMqttAgent extends MqttAgent{

  IssMqttAgent(Function(String, List<int>, DateTime, DateTime?, String) processingFunction): super("ISS", processingFunction);

  @override
  Future<int> connect() async{
    String connectionUrl = "mqtt://54.203.234.183:1883"; // TODO load this from settings
    logger.i("Connecting MQTT Agent $agentName");

    int result = await mqttService.connect(connectionUrl, null);
    if (result != 0) {
      logger.e("${agentName} unable to connect to MQTT Broker $connectionUrl");
      return 1;
    }

    return 0;
  }

  @override
  Future<int> setupSubscribers() async{
    // Hardcoding for now, should be loaded from API in the future
    mqttService.subscribe("v2x/ta", callback); // Topic for App PSM / BSM Traffic
    mqttService.subscribe("v2x/ta-srm", callback); // SRM messages from ISS App, SSMs from RSU units
    mqttService.subscribe("v2x/midot/psm", callback); // PSM messages from RSUs
    mqttService.subscribe("v2x/midot/bsm", callback); // BSM messages from RSUs
    mqttService.subscribe("v2x/midot/tim​", callback); // TIM messages from RSUs
    mqttService.subscribe("v2x/midot/sdsm​", callback); // SDSM messages from RSUs
    mqttService.subscribe("v2x/midot/map", callback); // MAP messages from RSUs
    mqttService.subscribe("v2x/spat/+", callback); // SPaT messages from all Intersections

    return 0;
  }

  @override 
  int sendMessage(List<int> message, MsgType messageType){
    Uint8Buffer buffer = Uint8Buffer();
    buffer.addAll(message);

    switch (messageType) {
      case MsgType.BSM:
        print("Sending BSM to ISS");
        mqttService.publishBytes(buffer, "v2x/ta");
        break;
      case MsgType.PSM:
        mqttService.publishBytes(buffer, "v2x/ta");
        break;
      default:
        throw UnimplementedError('$agentName does not support sending ${messageType.name} messages');
    }
    return 0;
  }
}