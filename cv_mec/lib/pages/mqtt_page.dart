import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:connection_network_type/connection_network_type.dart';
import 'package:cv_mec/models/dataQueue.dart';
import 'package:cv_mec/models/geoRoutedMsg.pb.dart' as protobuf;
import 'package:cv_mec/models/registration.dart';
import 'package:cv_mec/pages/config_page.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/mqtt_service.dart';
import 'package:cv_mec/services/api_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:cv_mec/services/timing.dart';
import 'package:device_info/device_info.dart';
import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cv_mec/pages/settings_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:typed_data/typed_data.dart';
import 'package:telephony/telephony.dart';

class MQTTTesting extends StatefulWidget {
  const MQTTTesting({super.key});

  @override
  _MQTTTestingState createState() => _MQTTTestingState();
}

class _MQTTTestingState extends State<MQTTTesting> {
  final MqttService mqtt = MqttService();
  final ApiService api = ApiService();
  final ASNService asn = ASNService();
  final FileService fileService = FileService();
  final Timing timingService = Get.find<Timing>();
  final Telephony telephony = Telephony.instance;

  ParamController controller = Get.find<ParamController>();
  SettingsController settingsController = Get.find<SettingsController>();
  final ScrollController sendController = ScrollController();
  final ScrollController recController = ScrollController();

  final List<String> receivedLog = [];
  final List<String> appLog = [];

  String param1 = 'Not Set';
  String param2 = 'Not Set';

  String publishTopic = "";
  String subscribeTopic = "";
  String v2xType = "BSM"; //Parameter
  int messageDelay = 100; // ms Parameter

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isBroadcastingLocation = false;
  bool isLogging = false;

  File? recLogFile;
  File? sendLogFile;

  DataQueue? recDataQueue;
  DataQueue? pubDataQueue;

  Registration? registration;
  String? mqttConnectionURL;

  late LocationService _locationService;
  StreamSubscription<Position>? _positionStream;
  Position? currentPosition;
  Timer? _timer;

  late Pointer<Pointer<Void>> bsmTemplate;

  _MQTTTestingState() {
    _locationService = Get.find<LocationService>();
    bsmTemplate = asn.getTemplateBSM();
    asn.parseBSM(bsmTemplate);

    // Pointer<Pointer<Void>> tim = asn.decode(asn.timTemplate);
    // asn.parseTim(tim);
    final tim = asn.decodeTim(asn.timTemplate);
    _positionStream = _locationService.locationStream.listen(updatePosition);
  }

  void dispose() {
    asn.cleanupBSMTemplate(bsmTemplate);
  }

  void _scrollSendToBottom() {
    sendController.animateTo(
      sendController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  void _scrollRecToBottom() {
    recController.animateTo(
      recController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  void startSending() {
    // Stop any previous timer
    _timer?.cancel();
    //_positionStream?.cancel();
    _positionStream = _locationService.locationStream.listen(updatePosition);
    asn.randomizeBsmId(bsmTemplate);

    // Set the timer to call _runFunction every 100 milliseconds
    _timer = Timer.periodic(Duration(milliseconds: messageDelay), (timer) {
      sendPosition();

      if (!isConnected()) {
        stopSending();
        setState(() {
          isLogging = false;
          isBroadcastingLocation = false;
        });
      }
    });
  }

  void stopSending() {
    _timer?.cancel();
    //_positionStream?.cancel();
  }

  void onReceieve(
      MqttReceivedMessage<MqttMessage?> message, DateTime recTime) async {
    final recMess = message.payload as MqttPublishMessage;

    protobuf.GeoRoutedMsg decodedMessage =
        protobuf.GeoRoutedMsg.fromBuffer(recMess.payload.message);

    DateTime msgTime = timeStampToDateTime(decodedMessage.time);
    setState(() {
      receivedLog.add(
          "Receieved ${msgTime.millisecondsSinceEpoch} Time Delta (ms): ${recTime.millisecondsSinceEpoch - msgTime.millisecondsSinceEpoch}");
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollRecToBottom();
    });

    if (isLogging) {
      String netStat = "Unavailable";
      if (Platform.isAndroid) {
        netStat = "${await getNetworkField()}";
      }
      String record =
          "${message.topic},${recTime.millisecondsSinceEpoch},${msgTime.millisecondsSinceEpoch},${recTime.millisecondsSinceEpoch - msgTime.millisecondsSinceEpoch},${decodedMessage.position.longitude},${decodedMessage.position.latitude},${netStat},$mqttConnectionURL,${utf8.decode(decodedMessage.msgBytes)}\n";
      if (recDataQueue != null) {
        recDataQueue!.addItem(record);
      }
    }
  }

  void sendPosition() async {
    if (isBroadcastingLocation) {
      protobuf.GeoRoutedMsg msg = protobuf.GeoRoutedMsg();

      protobuf.Position pos = protobuf.Position();

      if (currentPosition != null && !controller.useFakePositionToggle.value) {
        pos.longitude = currentPosition!.longitude;
        pos.latitude = currentPosition!.latitude;
      } else {
        pos.latitude = controller.fakeLatitude.value;
        pos.longitude = controller.fakeLongitude.value;
      }

      DateTime sendTime = timingService.getKronosTime();

      Uint8Buffer buffer = Uint8Buffer();
      msg.position = pos;

      asn.setBsmLongLat(bsmTemplate, pos.longitude, pos.latitude);
      asn.incrementBsmMsgCnt(bsmTemplate);

      asn.setBsmTime(bsmTemplate, sendTime);

      msg.msgBytes = utf8.encode(asn.encode(bsmTemplate));

      print(asn.encode(bsmTemplate));

      // msg.msgBytes = utf8.encode(
      //     "0022e12d18466c65c1493800000e00e4616183e85a8f0100c000038081bc001480b8494c4c950cd8cde6e9651116579f22a424dd78fffff00761e4fd7eb7d07f7fff80005f11d1020214c1c0ffc7c016aff4017a0ff65403b0fd204c20ffccc04f8fe40c420ffe6404cefe60e9a10133408fcfde1438103ab4138f00e1eec1048ec160103e237410445c171104e26bc103dc4154305c2c84103b1c1c8f0a82f42103f34262d1123198103dac25fb12034ce10381c259f12038ca103574251b10e3b2210324c23ad0f23d8efffe0000209340d10000004264bf00");

      msg.time = dateTimeToTimestamp(sendTime);

      buffer.addAll(msg.writeToBuffer());

      int messageID = mqtt.publishBytes(buffer, publishTopic);
      addToAppLog("Sent: ${sendTime.millisecondsSinceEpoch}");
      if (isLogging) {
        if (pubDataQueue != null) {
          NetworkStatus networkStatus =
              await ConnectionNetworkType().currentNetworkStatus();
          String netStat = "Unavailable";
          if (Platform.isAndroid) {
            netStat = "${await getNetworkField()}";
          }
          String record =
              "$publishTopic,${sendTime.millisecondsSinceEpoch},${pos.longitude},${pos.latitude},${netStat},$mqttConnectionURL,${utf8.decode(msg.msgBytes)}\n";
          pubDataQueue!.addItem(record);
        }
      }
    }
  }

  void updatePosition(Position position) {
    currentPosition = position;
  }

  void addToAppLog(String message) {
    setState(() {
      appLog.add(message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollSendToBottom();
    });
  }

  void getPermission() async {
    await Geolocator.requestPermission();
  }

  void deleteRegistration() async {
    //await fileService.requestPermissions();
    bool didDelete = await fileService.deleteRegistration();
    registration = null;
    if (didDelete) {
      addToAppLog("Deleted Registration Cache");
    } else {
      addToAppLog("No Registration Cache to delete");
    }
  }

  void connectToMqttBroker() async {
    timingService.startAllUpdates();
    if (mqttConnectionURL != null && registration != null) {
      int result = await mqtt.connect(mqttConnectionURL!, registration!);
      if (result == 0) {
        addToAppLog("Connected to MQTT Broker");

        if (controller.geoRelevanceOrPrivate) {
          if (controller.privateDeviceID == "self") {
            publishTopic =
                "vzimp/1/Private/${registration!.deviceID}/${controller.clientType}/${controller.clientSubtype}/${settingsController.vendorID.value}/${controller.messageFormat}/${v2xType}";
          } else {
            publishTopic =
                "vzimp/1/Private/${controller.privateDeviceID}/${controller.clientType}/${controller.clientSubtype}/${settingsController.vendorID.value}/${controller.messageFormat}/${v2xType}";
          }

          subscribeTopic =
              "vzimp/1/Private/+/+/+/${controller.messageFormat.value}/+/+";
        } else {
          publishTopic =
              "vzimp/1/GeoRelevance/${controller.clientType.value}/${controller.clientSubtype.value}/Public/${controller.messageFormat}/$v2xType";
          subscribeTopic =
              "vzimp/1/GeoRelevance/+/+/Public/${controller.messageFormat}/+/+";
        }

        addToAppLog("Publish Topic $publishTopic");

        // mqtt.subscribe(subscribeTopic, onReceieve);
        mqtt.subscribe(subscribeTopic, onReceieve);
        addToAppLog("Subscribed to Topic $subscribeTopic");
      } else {
        addToAppLog("Failed to connect to MQTT Broker");
      }
    } else {
      addToAppLog(
          "MQTT Connection is not available because the connection URL or Registration are missing");
    }
  }

  void toggleConnection() {
    if (registration != null) {
      if (isConnected()) {
        disconnect();
      } else {
        connectToMqttBroker();
      }
    }
  }

  void toggleBroadcasting() async {
    addToAppLog("Toggle Broadcasting");
    setState(() {
      isBroadcastingLocation = !isBroadcastingLocation;
    });

    if (isBroadcastingLocation) {
      startSending();
    } else {
      stopSending();
    }
  }

  void toggleLogging() async {
    if (!isLogging) {
      if (Platform.isAndroid) {
        await Permission.phone.request();
      }
    }
    setState(() {
      isLogging = !isLogging;
    });
    if ((isLogging && Platform.isIOS) ||
        (isLogging && await Permission.phone.request().isGranted)) {
      // await Permission.manageExternalStorage.isGranted;
      //await fileService.requestPermissions();
      if (Platform.isAndroid) {
        await telephony.requestPhoneAndSmsPermissions;
      }

      DateTime logTime = timingService.getKronosTime();
      recLogFile = await fileService.getFileForWriting(
          "MQTT_SUB_LOG_${logTime.millisecondsSinceEpoch}.csv");

      recDataQueue = DataQueue(recLogFile!);
      sendLogFile = await fileService.getFileForWriting(
          "MQTT_PUB_LOG_${logTime.millisecondsSinceEpoch}.csv");

      pubDataQueue = DataQueue(sendLogFile!);
      addToAppLog("Saving Records to ${recLogFile!.path}");
      String subHeader =
          "Topic, Receive Time ms, Send Time ms, Delta Time ms, Longitude, Latitude, Network, Broker, Msg Bytes\n";

      recDataQueue!.addItem(subHeader);

      String pubHeader =
          "Topic, Send Time ms, Longitude, Latitude, Network, Broker, Msg Bytes\n";
      pubDataQueue!.addItem(pubHeader);
    } else {}
  }

  void disconnect() async {
    mqtt.disconnect();
    mqtt.subscriberList.clear();
    addToAppLog("Disconnected from Broker");
  }

  bool isConnected() {
    return mqtt.client != null &&
        mqtt.client!.connectionStatus!.state == MqttConnectionState.connected;
  }

  Future<String> getNetworkField() async {
    NetworkType type = await telephony.dataNetworkType;
    List<SignalStrength> strenghts = await telephony.signalStrengths;

    String signalStrength = "NONE_OR_UNKNOWN";
    if (strenghts.isNotEmpty) {
      signalStrength = enumToString(strenghts[0]);
    }

    return "${enumToString(type)} $signalStrength";
  }

  String enumToString(Object o) => o.toString().split('.').last;

  protobuf.Timestamp dateTimeToTimestamp(DateTime dateTime) {
    protobuf.Timestamp time = protobuf.Timestamp();
    time.seconds = Int64(dateTime.millisecondsSinceEpoch ~/ 1000);
    time.nanos =
        (dateTime.millisecond * 1E6 + dateTime.microsecond * 1000).toInt();
    return time;
  }

  DateTime timeStampToDateTime(protobuf.Timestamp timeStamp) {
    DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
        (timeStamp.seconds.toInt() * 1E6).toInt() + timeStamp.nanos ~/ 1000);
    return dt;
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = "CV-MEC";
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: const Text(appTitle),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Get.to(() => SettingsPage());
                }),
          ],
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Get.dialog(ConfigDialogTwo()),
              /*_openConfigDialog*/
              child: const Text('Configure MQTT Connection'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () async {
                  //fileService.requestPermissions();
                  addToAppLog("Getting Token from Server");
                  String? token = await api.getToken();
                  print("Got Token $token");
                  addToAppLog("Retrieving Certificates");

                  if (token != null) {
                    // if (await fileService.checkIfRegistrationExists()) {
                    //   addToAppLog("Loading Registration from Cache");
                    //   registration = await fileService.getRegistration();
                    // } else {
                    addToAppLog("Loading Registration from Server");
                    registration = await api.getRegistration(
                        token,
                        controller.clientType.value,
                        controller.clientSubtype.value);
                    // }
                    if (registration != null) {
                      fileService.saveRegistration(registration!);
                      addToAppLog(
                          "Acquired Certificates for DeviceID: ${registration!.deviceID}");
                      mqttConnectionURL = await api.getConnection(
                          token,
                          registration!.deviceID,
                          controller.fakeLatitude.value,
                          controller.fakeLongitude.value,
                          controller.networkType.value);
                      addToAppLog(
                          "Acquired MQTT Connection String: $mqttConnectionURL");
                    } else {
                      addToAppLog("Failed to Register application");
                    }
                  } else {
                    addToAppLog("Unable to authenticate with Vendor API");
                  }
                },
                child: const Text('Register Device'),
              ),
              // ElevatedButton(
              //   onPressed: deleteRegistration,
              //   child: Text("Delete Registration"),
              // ),
            ]),
            ElevatedButton(
              onPressed: registration != null ? toggleConnection : null,
              child: Text(!isConnected() ? "Connect" : "Disconnect"),
            ),
            ElevatedButton(
              onPressed: mqtt.client != null &&
                      mqtt.client!.connectionStatus!.state ==
                          MqttConnectionState.connected
                  ? toggleBroadcasting
                  : null,
              child: Text(isBroadcastingLocation
                  ? "Stop Broadcasting"
                  : "Start Broadcasting"),
            ),
            ElevatedButton(
              onPressed: isConnected() ? toggleLogging : null,
              child: Text(!isLogging ? 'Start Logging' : "Stop Logging"),
            ),
            const Text("Send Message Log"),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  controller: sendController,
                  itemCount: appLog.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(appLog[index]),
                    );
                  },
                ),
              ),
            ),
            const Text("Received Message Log"),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  controller: recController,
                  itemCount: receivedLog.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(receivedLog[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        )));
  }
}
