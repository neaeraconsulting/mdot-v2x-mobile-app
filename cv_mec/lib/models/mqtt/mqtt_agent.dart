import 'package:cv_mec/models/msg_types.dart';
import 'package:cv_mec/services/mqtt_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttAgent{
  
  String agentName;
  MqttService mqttService = MqttService();
  Logger logger = Logger();
  Function(String, List<int>, DateTime, DateTime?, String) processingFunction;

  

  MqttAgent(this.agentName, this.processingFunction){}

  // Template function to connect this agent to the specified broker. 
  Future<int> connect() async{
    throw UnimplementedError('connect method not implemented for mqtt agent $agentName');
  }

  // Template function for linking MQTT callback functions.
  Future<int> setupSubscribers(){
    throw UnimplementedError('setupSubscribers method not implemented for mqtt agent $agentName');
  }

  Future<int> updateSubscribers(Position pos){
    throw UnimplementedError('updateSubscribers method not implemented for mqtt agent $agentName');
  }

  int sendMessage(List<int> message, MsgType messageType){
    throw UnimplementedError('sendMessage method not implemented for mqtt agent $agentName');
  }

  void callback(MqttReceivedMessage<MqttMessage?> message, DateTime recTime){
    final recMess = message.payload as MqttPublishMessage;
    print("Agent Callback received data");
    processingFunction(message.topic, recMess.payload.message, recTime, null, agentName);
  }

  bool isConnected() {
    return mqttService.client != null && mqttService.client!.connectionStatus!.state == MqttConnectionState.connected;
  }
}