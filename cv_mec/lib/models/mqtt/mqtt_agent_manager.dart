import 'package:cv_mec/models/mqtt/mqtt_agent.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:logger/logger.dart';

class MqttAgentManager{
  List<MqttAgent> agents = [];
  Logger logger = Logger();
  MqttAgentManager(){}

  Future<int> connectAll() async{
    for(MqttAgent agent in agents){
      logger.i("Connecting Agent ${agent.agentName}");
      final success = await agent.connect();
      if(success != 0){
        logger.w("Unable to Connect Agent ${agent.agentName}");
      }
    }
    return 0;
  }

  void addAgent(MqttAgent agent){
    agents.add(agent);
  }

  void clearAgents(){
    agents.clear();
  }

  void disconnectAll(){
    for(MqttAgent agent in agents){
      agent.mqttService.disconnect();
    }
  }

  void sendMessage(List<int> message, MsgType messageType){
    for(MqttAgent agent in agents){
      if(agent.isConnected()){
        agent.sendMessage(message, messageType);
      }
    }
  }
}