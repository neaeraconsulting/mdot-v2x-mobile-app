import 'package:cv_mec/models/mqtt/mqtt_agent.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:typed_data/typed_data.dart';

class IssMqttAgent extends MqttAgent{

  IssMqttAgent(Function(String?, String, List<int>, DateTime, DateTime?, String) processingFunction): super("ISS", processingFunction);

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
    mqttService.subscribe("v2x/+/psm",callback);
    mqttService.subscribe("v2x/+/bsm",callback);
    mqttService.subscribe("v2x/+/psm",callback);
    mqttService.subscribe("v2x/spat/+", callback);
    mqttService.subscribe("v2x/midot/+", callback);
    mqttService.subscribe("v2x/stol/psm", callback);
    mqttService.subscribe("v2x/stol/bsm", callback);
    return 0;
  }

  @override 
  String sendMessage(List<int> message, MsgType messageType, DateTime sendTime){
    Uint8Buffer buffer = Uint8Buffer();
    buffer.addAll(message);

    String topic = "";
    switch (messageType) {
      case MsgType.BSM:
        topic = "v2x/stol/bsm";
        break;
      case MsgType.PSM:
        topic = "v2x/stol/psm";
        break;
      default:
        logger.e('$agentName does not support sending ${messageType.name} messages');
        break;
    }

    mqttService.publishBytes(buffer, topic);
    return topic;
  }
}