import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:connection_network_type/connection_network_type.dart';
import 'package:cv_mec/models/data_queue.dart';
import 'package:cv_mec/models/geometry_direction.dart';
import 'package:cv_mec/models/j2735/basic_safety_message.dart';
import 'package:cv_mec/models/j2735/d_second.dart';
import 'package:cv_mec/models/j2735/descriptive_name.dart';
import 'package:cv_mec/models/j2735/generic_lane.dart';
import 'package:cv_mec/models/j2735/intersection_state.dart';
import 'package:cv_mec/models/j2735/map_data.dart';
import 'package:cv_mec/models/j2735/minute_of_the_year.dart';
import 'package:cv_mec/models/j2735/movement_event.dart';
import 'package:cv_mec/models/j2735/movement_phase_state.dart';
import 'package:cv_mec/models/j2735/movement_state.dart';
import 'package:cv_mec/models/j2735/msg_count.dart';
import 'package:cv_mec/models/j2735/node_set_xy.dart';
import 'package:cv_mec/models/j2735/spat.dart';
import 'package:cv_mec/models/j2735/time_mark.dart';
import 'package:cv_mec/models/data_frame_geometry.dart';
import 'package:cv_mec/models/geo_map.dart';
import 'package:cv_mec/models/itis_code.dart';
import 'package:cv_mec/models/j2735/traveler_data_frame.dart';
import 'package:cv_mec/models/j2735/traveler_information.dart';
import 'package:cv_mec/models/leidos_date_extraction.dart';
import 'package:cv_mec/models/message_managers/map_manager.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:cv_mec/models/imp/registration.dart';
import 'package:cv_mec/models/receieved_bsm.dart';
import 'package:cv_mec/models/render_models/render_lane_connection.dart';
import 'package:cv_mec/models/render_models/render_light_location.dart';
import 'package:cv_mec/models/message_managers/spat_manager.dart';
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/models/message_managers/tim_manager.dart';
import 'package:cv_mec/models/type_definitions.dart';
import 'package:cv_mec/models/light_change_time.dart';
import 'package:cv_mec/models/utils.dart';
import 'package:cv_mec/services/api_service.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/aws_service.dart';
import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/mqtt_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:cv_mec/services/timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cv_mec/pages/settings_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:cv_mec/models/protobuf_models/geo_routed_msg.pb.dart'
    as protobuf;
import 'package:permission_handler/permission_handler.dart';
import 'package:typed_data/typed_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum ConnectedStatus { UNKNOWN, DISCONNECTED, CONNECTED, PARTIAl }

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapState createState() => MapState();
}

class MapState extends State<MapPage> {
  late MapController _mapController;

  ParamController paramController = Get.find<ParamController>();
  GeometryService geometryService = Get.find<GeometryService>();
  ASNService asnService = Get.find<ASNService>();
  ApiService apiService = Get.find<ApiService>();
  Timing timingService = Get.find<Timing>();
  FileService fileService = Get.find<FileService>();
  MqttService mqtt = Get.find<MqttService>();
  LocationService locationService = Get.find<LocationService>();
  SettingsController settingsController = Get.find<SettingsController>();
  S3Service awsService = Get.find<S3Service>();

  TimManager timManager = TimManager();
  MapManager mapManager = MapManager();
  SpatManager spatManager = SpatManager();

  Registration? registration;
  String? mqttConnectionURL;
  Position? currentPosition;

  late String publishTopic;
  late String publicGeoRelevanceRawSubscribeTopic;
  late String publicGeoRelevanceSubscribeTopic;
  late String privateSubscribeTopic;
  late String privateRawSubscribeTopic;

  Timer? bsmMessageTimer;
  late Pointer<Pointer<Void>> bsmTemplate;
  late Pointer<Pointer<Void>> psmTemplate;

  Timer? uploadTimer;

  Color connectedButtonColor = Colors.red;
  StreamSubscription<Position>? positionStream;

  Map<String, ReceivedBsm> receivedBsms = {};

  List<ItisCode> showTims = [];
  List<Polygon<HitValue>> drawnPolygons = [];
  List<Polyline<PolyLineHitValue>> drawnPolylines = [];
  List<Marker> lightMarkerList = [];

  bool followUser = true;

  late DataQueue recDataQueue;
  late DataQueue pubDataQueue;
  late DataQueue appLogQueue;
  late DataQueue timDataQueue;

  final LayerHitNotifier<HitValue> _hitNotifier = ValueNotifier(null);
  List<HitValue>? _prevHitValues;
  List<Polygon<HitValue>>? _hoverGons;

  final Map<MovementPhaseState, Image> lightStateMap = {
    MovementPhaseState.UNAVAILABLE:
        Image.asset("assets/images/Lights/traffic-light-icon-unknown.png"),
    MovementPhaseState.DARK:
        Image.asset("assets/images/Lights/traffic-light-icon-unknown.png"),
    MovementPhaseState.STOP_THEN_PROCEED:
        Image.asset("assets/images/Lights/traffic-light-icon-red-flashing.png"),
    MovementPhaseState.STOP_AND_REMAIN:
        Image.asset("assets/images/Lights/traffic-light-icon-red.png"),
    MovementPhaseState.PRE_MOVEMENT:
        Image.asset("assets/images/Lights/traffic-light-yellow-red.png"),
    MovementPhaseState.PERMISSIVE_MOVEMENT_ALLOWED:
        Image.asset("assets/images/Lights/traffic-light-icon-yellow.png"),
    MovementPhaseState.PROTECTED_MOVEMENT_ALLOWED:
        Image.asset("assets/images/Lights/traffic-light-icon-green.png"),
    MovementPhaseState.PROTECTED_CLEARANCE:
        Image.asset("assets/images/Lights/traffic-light-icon-yellow.png"),
    MovementPhaseState.PERMISSIVE_CLEARANCE:
        Image.asset("assets/images/Lights/traffic-light-icon-yellow.png"),
    MovementPhaseState.CAUTION_CONFLICTING_TRAFFIC:
        Image.asset("assets/images/Lights/traffic-light-icon-yellow.png")
  };

  late Image currentLightState;
  late String nextLightText = "";

  bool debugMode = false;
  bool showLoadingIcon = true;
  bool showLightText = true;

  @override
  void initState() {
    super.initState();
    showLoadingIcon = true;
    _mapController = MapController();
    timingService.startAllUpdates();
    bsmTemplate = asnService.decode(asnService.bsmTemplate);
    asnService.randomizeBsmId(bsmTemplate);

    psmTemplate = asnService.decode(asnService.psmTemplate);
    asnService.randomizePsmId(psmTemplate);

    publishTopic =
        "vzimp/1/GeoRelevance/${paramController.clientType.value}/${paramController.clientSubtype.value}/Public/${paramController.messageFormat}/BSM";

    publicGeoRelevanceSubscribeTopic =
        "vzimp/1/GeoRelevance/+/+/Public/j2735_gr/+/+";
    publicGeoRelevanceRawSubscribeTopic =
        "vzimp/1/GeoRelevance/+/+/Public/j2735/+/+";

    privateSubscribeTopic = "vzimp/1/Private/+/+/+/j2735_gr/+/+";
    privateRawSubscribeTopic = "vzimp/1/Private/+/+/+/j2735/+/+";

    currentLightState = lightStateMap[MovementPhaseState.UNAVAILABLE]!;

    if (debugMode) {
      // TravelerInformation tim =
      //     asnService.decodeTim(TestData.pedestrianCrossingTim);
      // timManager.addOrUpdate(tim, TestData.pedestrianCrossingTim);

      // TravelerInformation tim2 = asnService.decodeTim(asnService.verizonTim2);
      // timManager.addOrUpdate(tim2, asnService.verizonTim2);

      // TravelerInformation tim3 = asnService.decodeTim(asnService.longQueueTim);
      // timManager.addOrUpdate(tim3, asnService.queueTim);
      // TravelerInformation tim4 = asnService.decodeTim(asnService.testTimTemplate);
      // timManager.addOrUpdate(tim4, asnService.testTimTemplate);

      // MapData map = asnService.decodeMap(TestData.cdotTestMap12110);
      // PersonalSafetyMessage psm = asnService.decodePsm(TestData.testPsm);

      // mapManager.addOrUpdate(map);

      // fakeSpatMessages(TestData.tfhrcFakeSpats);
    }

    Future.delayed(Duration.zero, () async {
      int loggingEnabled = await enableLogging();
      if (loggingEnabled != 0) {
        return;
      }

      int connected = await connectToMqttBroker();
      if (connected != 0) {
        return;
      }

      updateConnectedStatus(ConnectedStatus.CONNECTED);

      if (debugMode) {
        positionStream =
            fakePosition(TestData.tfhrcStaticPosition).listen(updatePosition);
      } else {
        positionStream = locationService.locationStream.listen(updatePosition);
      }
    });

    if (mounted) {
      setState(() {
        drawnPolygons = getPolygons();
        drawnPolylines = getPolylines();
        showLoadingIcon = true;
      });
    }
  }

  void fakeSpatMessages(List<String> fakeSpats) {
    int spatSimStartTime =
        timingService.getKronosTime().toUtc().millisecondsSinceEpoch;
    int yearStartMs = DateTime(timingService.getKronosTime().year, 1, 1)
        .millisecondsSinceEpoch;

    int revision = 0;

    int minEndTime = 0;
    int maxEndTime = 0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      DateTime now = timingService
          .getKronosTime()
          .toUtc()
          .subtract(DateTime.now().timeZoneOffset);

      int deltaMs = (now.millisecondsSinceEpoch - spatSimStartTime);

      int index = (deltaMs ~/ 100) % fakeSpats.length;

      if ((deltaMs ~/ 100) % 600 == 0) {
        minEndTime = now.minute * 600 + now.second * 10 + 300;
        maxEndTime = now.minute * 600 + now.second * 10 + 350;
      }

      Spat spat = asnService.decodeSpat(fakeSpats[index]);

      spat.timeStamp =
          MinuteOfTheYear((now.millisecondsSinceEpoch - yearStartMs) ~/ 60000);

      for (IntersectionState state
          in spat.intersections.intersectionStateList) {
        state.moy = spat.timeStamp;
        state.timeStamp = DSecond(now.second * 1000 + now.millisecond);
        state.revision = MsgCount(revision);

        for (MovementState movementState in state.states.movementList) {
          for (MovementEvent event
              in movementState.state_time_speed.movementEventList) {
            if (event.timing != null) {
              event.timing!.minEndTime = TimeMark(minEndTime);
              event.timing!.maxEndTime = TimeMark(maxEndTime);
            }
          }
        }
      }

      revision = (revision + 1) % 127;
      spatManager.addOrUpdate(spat);

      await Future.delayed(
          const Duration(milliseconds: 100)); // Simulate an async task
    });
  }

  Stream<Position> fakePosition(List<List<double>> fakePosition) {
    return Stream<Position>.periodic(const Duration(milliseconds: 500),
        (count) {
      List<List<double>> route = fakePosition; //.reversed.toList();
      int index = count % route.length;
      int prevIndex = (count - 1) % route.length;

      List<double> pos = route[index];
      List<double> lastPos = route[prevIndex];

      double heading =
          radianToDeg(atan2(pos[1] - lastPos[1], pos[0] - lastPos[0]));

      heading = -heading + 90;
      if (heading < 0) {
        heading += 360;
      }
      return Position(
          longitude: route[index][0],
          latitude: route[index][1],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 1600,
          altitudeAccuracy: 0,
          heading: heading,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0);
    });
  }

  Future<int> enableLogging() async {
    DateTime logTime = timingService.getKronosTime();

    recDataQueue =
        DataQueue("MQTT_SUB_LOG_${logTime.millisecondsSinceEpoch}.csv");
    pubDataQueue =
        DataQueue("MQTT_PUB_LOG_${logTime.millisecondsSinceEpoch}.csv");
    appLogQueue = DataQueue("APP_LOG_${logTime.millisecondsSinceEpoch}.log");
    timDataQueue = DataQueue("TIM_LOG_${logTime.millisecondsSinceEpoch}.csv");
    String subHeader =
        "topic,message_type,receive_time_ms,send_time_ms,generation_time_ms,send_rec_delta_time_ms,gen_rec_delta_time_ms,longitude,latitude,broker,msg_bytes\n";
    String pubHeader =
        "topic,send_time_ms,longitude,latitude,broker,msg_bytes\n";
    String timHeader = "action,time,longitude,latitude,heading,asn1\n";

    recDataQueue.addItem(subHeader);
    pubDataQueue.addItem(pubHeader);
    timDataQueue.addItem(timHeader);

    uploadTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      uploadAllLogs();
    });

    return 0;
  }

  Future<int> connectToMqttBroker() async {
    String? token = await apiService.getToken();

    if (mounted) {
      setState(() {
        showLoadingIcon = true;
      });
    }

    updateConnectedStatus(ConnectedStatus.PARTIAl);

    if (token == null) {
      showError(
          "Unable to retrieve token from partner API. Please verify partner API credentials in settings menu");
      return 1;
    }

    //Add Loading Registration from Cache
    if (await fileService.checkIfRegistrationExists()) {
      addToAppLog("Loading Registration from Cache");
      registration = await fileService.getRegistration();
    } else {
      addToAppLog("Loading Registration from Server");
      registration = await apiService.getRegistration(
          token,
          paramController.clientType.value,
          paramController.clientSubtype.value);

      if (registration != null) {
        fileService.saveRegistration(registration!);
      }
    }

    if (registration == null) {
      showError("Unable to retrieve registration information from partner API");
      return 2;
    }

    addToAppLog(
        "Acquired Certificates for DeviceID: ${registration!.deviceID}");

    String vzString = paramController.networkType.value;

    if (settingsController.vzMode.value) {
      vzString = "VZ";
    } else {
      vzString = "non-VZ";
    }

    mqttConnectionURL = await apiService.getConnection(
        token,
        registration!.deviceID,
        paramController.fakeLatitude.value,
        paramController.fakeLongitude.value,
        vzString);

    int result = await mqtt.connect(mqttConnectionURL!, registration!);
    if (result != 0) {
      showError("Unable to Connect to MQTT Broker");
      return 3;
    }

    mqtt.subscribe(privateRawSubscribeTopic, onRawAsnMessage); //MAP / TIM
    mqtt.subscribe(privateSubscribeTopic, onGeoRelevanceMessage);
    mqtt.subscribe(
        publicGeoRelevanceRawSubscribeTopic, onRawAsnMessage); // SPaT
    mqtt.subscribe(publicGeoRelevanceSubscribeTopic, onGeoRelevanceMessage);

    //cdotFakePosition

    startSendingBSM();
    WakelockPlus.enable();

    if (mounted) {
      setState(() {
        showLoadingIcon = false;
      });
    }

    return 0;
  }

  void onGeoRelevanceMessage(
      MqttReceivedMessage<MqttMessage?> message, DateTime recTime) async {
    addToAppLog("Received Geo Relevance Message");

    final recMess = message.payload as MqttPublishMessage;

    protobuf.GeoRoutedMsg decodedMessage =
        protobuf.GeoRoutedMsg.fromBuffer(recMess.payload.message);

    DateTime msgTime = Utils.timeStampToDateTime(decodedMessage.time);

    addToAppLog(
        "${decodedMessage.position.longitude}, ${decodedMessage.position.latitude}");

    String hex = ASNService.bytesToHex(decodedMessage.msgBytes);
    processIncomingMessage(message.topic, hex, recTime, msgTime);
  }

  void onRawAsnMessage(
      MqttReceivedMessage<MqttMessage?> message, DateTime recTime) {
    addToAppLog("Received ASN1 Message");
    final recMess = message.payload as MqttPublishMessage;
    String hex = ASNService.bytesToHex(recMess.payload.message);
    processIncomingMessage(message.topic, hex, recTime, null);
  }

  void processIncomingMessage(
      String topic, String hex, DateTime recTime, DateTime? sendTime) {
    addToAppLog("Identified Message as BSM");
    MsgType msgType = asnService.determineHexMessageType(hex);

    if (msgType == MsgType.BSM) {
      String trimmedHex =
          asnService.trimMessageHeaders(hex, asnService.BSM_START_FLAG)!;
      BasicSafetyMessage bsm = asnService.decodeBsm(trimmedHex);

      LatLng position = LatLng(bsm.coreData.lat.getDecimalLatitude(),
          bsm.coreData.long.getDecimalLongitude());
      String vehicleID = ASNService.bytesToHex(bsm.coreData.id.temporaryID);

      DateTime bsmTime = bsm.coreData.secMark.getDateTime(recTime);

      if (receivedBsms.containsKey(vehicleID)) {
        if (receivedBsms[vehicleID]!.dateTime.isBefore(bsmTime)) {
          receivedBsms[vehicleID] = ReceivedBsm(vehicleID, bsmTime, position);
        }
      } else {
        receivedBsms[vehicleID] = ReceivedBsm(vehicleID, bsmTime, position);
      }

      addToReceiveLog(topic, "BSM", recTime, sendTime, bsmTime, trimmedHex);
    } else if (msgType == MsgType.TIM) {
      addToAppLog("Identified Message as TIM");
      String trimmedHex = asnService.trimMessageHeaders(
          hex,
          asnService
              .TIM_START_FLAG)!; // Msg Type has already been identified, start flag guaranteed
      TravelerInformation tim = asnService.decodeTim(trimmedHex);

      timManager.addOrUpdate(tim, hex);
      if (mounted) {
        setState(() {
          drawnPolygons = getPolygons();
          drawnPolylines = getPolylines();
        });
      }
      DateTime? generationTime = LeidosDateExtraction.extractDateFromTim(tim);

      Future.delayed(const Duration(milliseconds: 0), () async {
        String messageType = "TIM";
        if (tim.dataFrames.travelerDataFrameList.isNotEmpty) {
          ItisCode code = await timManager.getItisRepresentationForDataFrame(
              tim.dataFrames.travelerDataFrameList.first);
          messageType = "TIM ${code.description}";
        }

        addToReceiveLog(
            topic, messageType, recTime, sendTime, generationTime, trimmedHex);
      });
    } else if (msgType == MsgType.SPAT) {
      addToAppLog("Identified Message as SPAT");
      String trimmedHex = asnService.trimMessageHeaders(
          hex,
          asnService
              .SPAT_START_FLAG)!; // Msg Type has already been identified, start flag guaranteed
      Spat spat = asnService.decodeSpat(trimmedHex);

      spatManager.addOrUpdate(spat);

      if (mounted) {
        setState(() {
          drawnPolygons = getPolygons();
          drawnPolylines = getPolylines();
        });
      }
      DateTime? spatGenTime;
      if (spat.intersections.intersectionStateList.isNotEmpty) {
        spatGenTime =
            spat.intersections.intersectionStateList.first.getUtcTime();
      }

      addToReceiveLog(
          topic, "SPAT", recTime, sendTime, spatGenTime, trimmedHex);
    } else if (msgType == MsgType.MAP) {
      addToAppLog("Identified Message as MAP $hex");
      String trimmedHex = asnService.trimMessageHeaders(
          hex,
          asnService
              .MAP_START_FLAG)!; // Msg Type has already been identified, start flag guaranteed
      MapData map = asnService.decodeMap(trimmedHex);

      mapManager.addOrUpdate(map);

      if (mounted) {
        setState(() {
          drawnPolygons = getPolygons();
          drawnPolylines = getPolylines();
        });
      }

      addToReceiveLog(topic, "MAP", recTime, sendTime,
          LeidosDateExtraction.extractDateFromMap(map), trimmedHex);
    }
  }

  void addToReceiveLog(String topic, String msgType, DateTime recTime,
      DateTime? sendTime, DateTime? generationTime, String hex) async {
    int delta = 0;
    int logSendTime = 0;
    if (sendTime != null) {
      delta = recTime.millisecondsSinceEpoch - sendTime.millisecondsSinceEpoch;
      logSendTime = sendTime.millisecondsSinceEpoch;
    }

    int generationDelta = 0;
    int messageGenerationTime = 0;
    if (generationTime != null) {
      generationDelta = recTime.millisecondsSinceEpoch -
          generationTime.millisecondsSinceEpoch;
      messageGenerationTime = generationTime.millisecondsSinceEpoch;
    }

    double longitude = 0;
    double latitude = 0;
    if (currentPosition != null) {
      longitude = currentPosition!.longitude;
      latitude = currentPosition!.latitude;
    }

    String record =
        "$topic, ${msgType.toString().split('.').last}, ${recTime.millisecondsSinceEpoch},$logSendTime,$messageGenerationTime,$delta,$generationDelta,$longitude,$latitude,$mqttConnectionURL,$hex\n";

    recDataQueue.addItem(record);
  }

  void showError(String message) {
    addToAppLog("ERROR: $message");
    // TODO
  }

  void addToAppLog(String message) {
    print("APPLOG: $message");
    appLogQueue.addItem("$message\n");
  }

  void startSendingBSM() {
    // Stop any previous timer
    bsmMessageTimer?.cancel();

    // Set the timer to call _runFunction every 100 milliseconds
    bsmMessageTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      sendMessage();
      if (!isConnected()) {
        stopSendingBSM();
        onMqttDisconnect();
      }
    });
  }

  void sendMessage() async {
    protobuf.GeoRoutedMsg msg = protobuf.GeoRoutedMsg();

    protobuf.Position pos = protobuf.Position();

    if (currentPosition == null) {
      addToAppLog("Cannot Send BSM. Location is Null");
      updateConnectedStatus(ConnectedStatus.PARTIAl);
      return;
    }

    pos.longitude = currentPosition!.longitude;
    pos.latitude = currentPosition!.latitude;

    DateTime sendTime = timingService.getKronosTime();

    Uint8Buffer buffer = Uint8Buffer();
    msg.position = pos;

    asnService.setBsmLongLat(bsmTemplate, pos.longitude, pos.latitude);
    asnService.incrementBsmMsgCnt(bsmTemplate);
    asnService.setBsmTime(bsmTemplate, sendTime);

    String hex = asnService.encode(bsmTemplate);

    msg.msgBytes = ASNService.hexToBytes(hex);

    msg.time = Utils.dateTimeToTimestamp(sendTime);

    buffer.addAll(msg.writeToBuffer());

    int messageID = mqtt.publishBytes(buffer, publishTopic);
    updateConnectedStatus(ConnectedStatus.CONNECTED);
    NetworkStatus networkStatus =
        await ConnectionNetworkType().currentNetworkStatus();
    String netStat = "Unavailable";
    if (Platform.isAndroid) {
      netStat = await getNetworkField();
    }
    String record =
        "$publishTopic,${sendTime.millisecondsSinceEpoch},${pos.longitude},${pos.latitude},$netStat,$mqttConnectionURL,$hex\n";
    pubDataQueue.addItem(record);
  }

  void stopSendingBSM() {
    bsmMessageTimer?.cancel();
  }

  DateTime prevNtp = DateTime.now();
  DateTime prevKronos = DateTime.now();
  DateTime prevLocal = DateTime.now();

  Future<void> updatePosition(Position position) async {
    currentPosition = position;

    DateTime now = DateTime.now();

    DateTime ntp = timingService.getNtpTime();
    DateTime kronos = timingService.getKronosTime();

    final timeDelta =
        now.millisecondsSinceEpoch - prevLocal.millisecondsSinceEpoch;

    prevNtp = ntp;
    prevKronos = kronos;
    prevLocal = now;

    if (mounted) {
      setState(() {
        drawnPolygons = getPolygons();
        drawnPolylines = getPolylines();
      });
    }

    if (followUser) {
      _mapController.moveAndRotate(getUserLocation(),
          _mapController.camera.zoom, _mapController.camera.rotation);
    }

    List<TravelerDataFrame> newActiveTims = [];

    List<TravelerDataFrame> frames = [];

    // if speed is less than 1 meter / second (~2.2 mph)
    if (position.speed < 1) {
      newActiveTims = timManager.getNewActiveTims(
          position.longitude, position.latitude, position.heading, true);

      frames = timManager.getTimsToShow(
          position.longitude, position.latitude, position.heading, true);
    } else {
      newActiveTims = timManager.getNewActiveTims(
          position.longitude, position.latitude, position.heading);

      frames = timManager.getTimsToShow(
          position.longitude, position.latitude, position.heading);
    }

    updateTimeToChange();

    List<ItisCode> codes =
        await timManager.getItisRepresentationForDataFrames(frames);

    List<String> hex = timManager.getUniqueAsnFromDataFrames(frames);
    for (String str in hex) {
      addToTimLog("ALERT", str);
    }

    if (mounted) {
      setState(() {
        showTims = codes;
      });
    }
    // showTimMessage(newActiveTims);
  }

  void onMqttDisconnect() {
    showError("Disconnected from MQTT Broker Randomly");
    updateConnectedStatus(ConnectedStatus.DISCONNECTED);
    stopSendingBSM();
    mqtt.subscriberList.clear();
    WakelockPlus.disable();
    uploadTimer?.cancel();
  }

  bool isConnected() {
    return mqtt.client != null &&
        mqtt.client!.connectionStatus!.state == MqttConnectionState.connected;
  }

  LatLng getUserLocation() {
    if (currentPosition != null) {
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    } else {
      return LatLng(paramController.fakeLatitude.value,
          paramController.fakeLongitude.value);
    }
  }

  void updateConnectedStatus(ConnectedStatus status) {
    if (mounted) {
      setState(() {
        if (status == ConnectedStatus.UNKNOWN) {
          connectedButtonColor = Colors.grey;
        } else if (status == ConnectedStatus.CONNECTED) {
          connectedButtonColor = Colors.green;
        } else if (status == ConnectedStatus.DISCONNECTED) {
          connectedButtonColor = Colors.red;
        } else if (status == ConnectedStatus.PARTIAl) {
          connectedButtonColor = Colors.orange;
        }
      });
    }
  }

  void updateTimeToChange() {
    DateTime now = timingService.getKronosTime();
    LightChangeTime? next;
    Position? pos = currentPosition;
    if (pos != null) {
      List<GeoMap> geoMaps =
          mapManager.getActiveMaps(pos.longitude, pos.latitude);

      for (GeoMap map in geoMaps) {
        List<int> activeLaneIds =
            mapManager.getActiveLaneIds(map, pos.longitude, pos.latitude);

        // if(activeLaneIds.isNotEmpty){
        List<int> signalGroups = [];
        for (int activeLane in activeLaneIds) {
          if (map.laneSignalGroups.containsKey(activeLane)) {
            signalGroups.addAll(map.laneSignalGroups[activeLane]!);
          }
        }

        for (int signalGroup in signalGroups) {
          LightChangeTime? timing = spatManager.getNextLaneTimeChange(
              map.intersectionGeometry.id.id.intersectionID, signalGroup, now);
          if (timing != null) {
            if (next == null || timing.minEndTime.isBefore(next.minEndTime)) {
              next = timing;
            }
          }
        }
      }

      if (next != null) {
        String text = "";
        if (next.likelyTime != null) {
          int nextExpectedChange = (next.likelyTime!.millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch) ~/
              1000;
          text = "$nextExpectedChange S";
          if (nextExpectedChange > 60) {
            text = "Change in:\n > 1\n Minute";
          } else if (nextExpectedChange < 0) {
            text = "Changing Now";
          }
        } else if (next.maxEndTime != null) {
          int expectedMaxTime = (next.maxEndTime!.millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch) ~/
              1000;
          int expectedMinTime = (next.minEndTime.millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch) ~/
              1000;

          text = "Change in:\n $expectedMinTime - $expectedMaxTime\n Seconds";
          if (expectedMinTime > 60) {
            text = "Change in:\n > 1\n Minute";
          } else if (expectedMinTime < 0) {
            text = "Changing Now";
          }
        } else {
          int expectedMinTime = (next.minEndTime.millisecondsSinceEpoch -
                  now.millisecondsSinceEpoch) ~/
              1000;
          text = "> $expectedMinTime Seconds";
          if (expectedMinTime > 60) {
            text = "Change in:\n > 1\n Minute";
          } else if (expectedMinTime < 0) {
            text = "Changing Now";
          }
        }

        if (mounted) {
          setState(() {
            currentLightState = lightStateMap[next!.currentPhaseState]!;
            nextLightText = text;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            currentLightState = lightStateMap[MovementPhaseState.UNAVAILABLE]!;
            nextLightText = "";
          });
        }
      }
    }
  }

  List<Marker> getMarkerList() {
    List<Marker> markerList = [];

    Position? pos = currentPosition;

    if (pos != null) {
      if (_mapController.camera.zoom > 17.5) {
        // Get Maps that the user is near or in
        List<GeoMap> geoMaps =
            mapManager.getActiveMaps(pos.longitude, pos.latitude);

        for (GeoMap map in geoMaps) {
          // Get SPaT messages associated with the relavent MAP messages
          List<IntersectionState> states = spatManager.getActiveSpats(
              map.intersectionGeometry.id.id.intersectionID,
              timingService.getKronosTime());

          for (IntersectionState state in states) {
            // This code indexes light colors by signal group to allow easy lookup down the line
            Map<int, MovementEvent> stateMap = {};
            for (MovementState movement in state.states.movementList) {
              if (movement.state_time_speed.movementEventList.isNotEmpty) {
                stateMap[movement.signalGroup.signalGroupID] =
                    movement.state_time_speed.movementEventList.first;
              }
            }

            for (RenderLightLocation lightLocation
                in map.lightLocations.values) {
              MovementPhaseState dominantState = MovementPhaseState.UNAVAILABLE;
              for (int signalGroup in lightLocation.signalGroups) {
                if (stateMap.containsKey(signalGroup)) {
                  dominantState = getDominantMovementPhaseState(
                      stateMap[signalGroup]!.eventState, dominantState);
                }
              }
              markerList.add(Marker(
                width: 20.0,
                height: 40.0,
                point: lightLocation.coordinate,
                child: lightStateMap[dominantState] ??
                    const Icon(
                      Icons.traffic,
                      color: Colors.grey,
                    ),
              ));
            }
          }
        }
      }

      Marker userMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: getUserLocation(),
        child: const Icon(
          Icons.directions_car,
          color: Colors.red,
        ),
      );

      markerList.add(userMarker);
    }

    DateTime compTime = timingService.getKronosTime();
    DateTime endTime = compTime.add(const Duration(seconds: 1));
    DateTime startTime = compTime.subtract(const Duration(seconds: 1));

    List<String> removeKeys = [];

    for (String key in receivedBsms.keys) {
      ReceivedBsm bsm = receivedBsms[key]!;

      if (bsm.dateTime.isAfter(startTime) && bsm.dateTime.isBefore(endTime)) {
        Marker remoteMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: bsm.position,
          child: Icon(Icons.directions_car, color: Colors.blue[900]),
        );

        markerList.add(remoteMarker);
      } else {
        removeKeys.add(key);
      }
    }

    for (String key in removeKeys) {
      receivedBsms.remove(key);
    }

    return markerList;
  }

  MovementPhaseState getDominantMovementPhaseState(
      MovementPhaseState a, MovementPhaseState b) {
    final priorityOrder = [
      MovementPhaseState.PROTECTED_MOVEMENT_ALLOWED,
      MovementPhaseState.PROTECTED_CLEARANCE,
      MovementPhaseState.PERMISSIVE_MOVEMENT_ALLOWED,
      MovementPhaseState.PERMISSIVE_CLEARANCE,
      MovementPhaseState.STOP_AND_REMAIN,
      MovementPhaseState.STOP_THEN_PROCEED,
      MovementPhaseState.PRE_MOVEMENT,
      MovementPhaseState.CAUTION_CONFLICTING_TRAFFIC,
      MovementPhaseState.DARK,
      MovementPhaseState.UNAVAILABLE,
    ];

    if (priorityOrder.indexOf(a) < priorityOrder.indexOf(b)) {
      return a;
    } else {
      return b;
    }
  }

  List<Polyline<PolyLineHitValue>> getPolylines() {
    List<Polyline<PolyLineHitValue>> polylines = [];

    Position? pos = currentPosition;

    if (pos != null) {
      // Get Maps that the user is near or in
      List<GeoMap> geoMaps =
          mapManager.getActiveMaps(pos.longitude, pos.latitude);

      for (GeoMap map in geoMaps) {
        // Get SPaT messages associated with the relavent MAP messages
        List<IntersectionState> states = spatManager.getActiveSpats(
            map.intersectionGeometry.id.id.intersectionID,
            timingService.getKronosTime());

        for (IntersectionState state in states) {
          // This code indexes light colors by signal group to allow easy lookup down the line
          Map<int, MovementEvent> stateMap = {};
          for (MovementState movement in state.states.movementList) {
            if (movement.state_time_speed.movementEventList.isNotEmpty) {
              stateMap[movement.signalGroup.signalGroupID] =
                  movement.state_time_speed.movementEventList.first;
            }
          }

          // Iterate over the pre-calculated lines and assign each connection a color
          for (RenderLaneConnection connection in map.laneConnections) {
            Color connectionColor = Colors.grey;
            StrokePattern pattern = const StrokePattern.dotted();
            if (stateMap.containsKey(connection.signalGroup)) {
              MovementPhaseState lightState =
                  stateMap[connection.signalGroup]!.eventState;

              if (lightState == MovementPhaseState.DARK) {
                connectionColor = Colors.grey.shade900;
                pattern = const StrokePattern.dotted();
              } else if (lightState == MovementPhaseState.STOP_THEN_PROCEED) {
                connectionColor = Colors.red;
                pattern = const StrokePattern.dotted();
              } else if (lightState == MovementPhaseState.STOP_AND_REMAIN) {
                connectionColor = Colors.red;
                pattern = const StrokePattern.solid();
              } else if (lightState == MovementPhaseState.PRE_MOVEMENT) {
                connectionColor = Colors.orange;
                pattern = const StrokePattern.dotted();
              } else if (lightState ==
                  MovementPhaseState.PERMISSIVE_MOVEMENT_ALLOWED) {
                connectionColor = Colors.green;
                pattern = const StrokePattern.dotted();
              } else if (lightState ==
                  MovementPhaseState.PROTECTED_MOVEMENT_ALLOWED) {
                connectionColor = Colors.green;
                pattern = const StrokePattern.solid();
              } else if (lightState == MovementPhaseState.PROTECTED_CLEARANCE) {
                connectionColor = Colors.yellow;
                pattern = const StrokePattern.solid();
              } else if (lightState ==
                  MovementPhaseState.CAUTION_CONFLICTING_TRAFFIC) {
                connectionColor = Colors.orange;
                pattern = const StrokePattern.solid();
              } else if (lightState ==
                  MovementPhaseState.PERMISSIVE_CLEARANCE) {
                connectionColor = Colors.yellow;
                pattern = const StrokePattern.dotted();
              }
            }

            Polyline<PolyLineHitValue> hitPoly = Polyline(
                points: connection.coordinates,
                borderColor: connectionColor,
                color: connectionColor,
                borderStrokeWidth: 1,
                strokeWidth: 1,
                hitValue: (name: "Connection ${polylines.length}"),
                pattern: pattern);

            polylines.add(hitPoly);
          }
        }

        for (GenericLane lane in map.intersectionGeometry.laneSet.laneList) {
          List<LatLng> laneCoordinates =
              geometryService.getLatLngCoordinatesFromNodeSetXY(
                  lane.nodeList.nodeListXY as NodeSetXY,
                  map.intersectionGeometry.refPoint);

          // Adds Ingress and Egress Map Lanes
          Color laneColor = Colors.blue.shade900;
          if (lane.ingressApproach != null) {
            laneColor = Colors.pink.shade300;
          }

          Polyline<PolyLineHitValue> hitPoly = Polyline(
            points: laneCoordinates,
            borderColor: laneColor,
            color: laneColor,
            borderStrokeWidth: 1,
            strokeWidth: 1,
            hitValue: (name: "Lane: ${lane.laneID}"),
          );
          polylines.add(hitPoly);

          // Add Connecting Lines for Map
          // if(lane.connectsTo != null){
          //   for(Connection connection in lane.connectsTo!.connectsTo){
          //     GenericLane connectingLane = connection.
          //   }
          // }
        }
      }
    }

    return polylines;
  }

  List<Polygon<HitValue>> getPolygons() {
    List<Polygon<HitValue>> polygons = [];

    List<DataFrameGeometry> dataFrames = timManager.getActiveTimGeometry();

    for (DataFrameGeometry frame in dataFrames) {
      TravelerDataFrame tdFrame = frame.frame;

      // ItisCode code = await timManager.getItisRepresentationForDataFrame(tdFrame);

      for (GeometryDirection geoDir in frame.geometry) {
        List<LatLng> polyPoints =
            geometryService.convertGeometryToLatLngList(geoDir.geometry);

        Polygon<HitValue> hitPoly = Polygon(
          points: polyPoints,
          borderColor: Colors.orangeAccent,
          color: const Color.fromARGB(128, 252, 173, 89),
          borderStrokeWidth: 1,
          hitValue: (frame: tdFrame,),
        );

        polygons.add(hitPoly);
      }
    }

    return polygons;
  }

  addToTimLog(String action, String asn1) {
    if (currentPosition != null) {
      timDataQueue.addItem(
          "$action, ${timingService.getKronosTime().millisecondsSinceEpoch}, ${currentPosition!.longitude}, ${currentPosition!.latitude}, ${currentPosition!.heading}, $asn1\n");
    } else {
      timDataQueue.addItem(
          "$action, ${timingService.getKronosTime().millisecondsSinceEpoch}, 0, 0, 0, $asn1\n");
    }
  }

  void uploadAllLogs() {
    if (settingsController.deviceID.value.isNotEmpty) {
      awsService.uploadFile(recDataQueue.filePath,
          "subscribe/${settingsController.deviceID.value}");
      awsService.uploadFile(pubDataQueue.filePath,
          "publish/${settingsController.deviceID.value}");
      awsService.uploadFile(
          pubDataQueue.filePath, "tim/${settingsController.deviceID.value}");
      awsService.uploadFile(
          pubDataQueue.filePath, "app/${settingsController.deviceID.value}");
    } else if (registration != null) {
      awsService.uploadFile(
          recDataQueue.filePath, "subscribe/${registration!.deviceID}");
      awsService.uploadFile(
          pubDataQueue.filePath, "publish/${registration!.deviceID}");
      awsService.uploadFile(
          pubDataQueue.filePath, "tim/${registration!.deviceID}");
      awsService.uploadFile(
          pubDataQueue.filePath, "app/${registration!.deviceID}");
    } else {
      addToAppLog("Cannot Upload Logs - Device ID is Unavailable");
    }
  }

  Future<String> getNetworkField() async {
    String networkType = "UNKNOWN";
    String signalStrength = "NONE_OR_UNKNOWN";

    return "$networkType $signalStrength";
  }

  String enumToString(Object o) => o.toString().split('.').last;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const String appTitle = "MAP";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              bsmMessageTimer?.cancel();
              positionStream?.cancel();
              uploadTimer?.cancel();
              mqtt.disconnect();

              Future.delayed(const Duration(milliseconds: 100), () async {
                Get.back();
              });
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
      body: Stack(alignment: AlignmentDirectional.topStart, children: [
        Center(child: map(context, _mapController)),
        Align(
          alignment: Alignment.topRight,
          child: showLightText && nextLightText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      width: screenWidth * 0.20,
                      // height: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.yellow.shade600,
                            width: 2.0), // Box border
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Rounded corners
                        color:
                            Colors.grey.shade800, // Optional: Background color
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text("Current Light State",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                            width: screenWidth * 0.15,
                            height: screenHeight * 0.15,
                            child: currentLightState),
                        Text(nextLightText,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ])))
              : (!showLightText && nextLightText.isNotEmpty)
                  ? SizedBox(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.15,
                      child: currentLightState)
                  : Container(),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Column(children: [
              ElevatedButton(
                onPressed: () {
                  updateConnectedStatus(ConnectedStatus.DISCONNECTED);
                  stopSendingBSM();
                  connectToMqttBroker();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: connectedButtonColor, // <-- Button color
                  foregroundColor: Colors.black, // <-- Splash color
                  shadowColor: Colors.black,
                ),
                // child: Icon(Icons.menu, color: Colors.white),
                child: const Icon(Icons.connect_without_contact_rounded,
                    color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  followUser = true;
                  _mapController.moveAndRotate(
                      getUserLocation(),
                      _mapController.camera.zoom,
                      _mapController.camera.rotation);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: followUser
                      ? Colors.green
                      : Colors.blue, // <-- Button color
                  foregroundColor: Colors.black, // <-- Splash color
                  shadowColor: Colors.black,
                ),
                // child: Icon(Icons.menu, color: Colors.white),
                child: const Icon(Icons.directions_car, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  addToAppLog("Upload Log Files");
                  uploadAllLogs();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black, // <-- Splash color
                  shadowColor: Colors.black,
                ),
                // child: Icon(Icons.menu, color: Colors.white),
                child: const Icon(Icons.upload, color: Colors.white),
              ),
            ])),
        Align(
            alignment: Alignment.bottomCenter,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: 150.0,
                  viewportFraction: 0.3,
                  enableInfiniteScroll: false),
              items: showTims.map((displayCode) {
                Color borderColor = Colors.blue;

                if (displayCode.status == ITIS_CODE_STATUS.VALID) {
                  borderColor = Colors.green;
                } else if (displayCode.status == ITIS_CODE_STATUS.UNKNOWN) {
                  borderColor = Colors.yellow;
                } else if (displayCode.status == ITIS_CODE_STATUS.ERROR) {
                  borderColor = Colors.red;
                }

                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: displayCode.image != null
                            ? Image(image: displayCode.image!)
                            : Text(
                                displayCode.description,
                                style: const TextStyle(fontSize: 16.0),
                              ));
                  },
                );
              }).toList(),
            )),
        Align(
          alignment: Alignment.center,
          child: showLoadingIcon
              ? const SpinKitSpinningLines(
                  color: Colors.white,
                  size: 140,
                  lineWidth: 4,
                )
              : null,
        )
      ]),
    );
  }

  Widget map(BuildContext context, MapController mapController) {
    return Obx(
      () => SizedBox(
        // width: screenWidthPercentage(context, percentage: orientation == Orientation.portrait ? 0.8 : 0.4),
        // height: screenHeightPercentage(context, percentage: orientation == Orientation.portrait ? 0.45 : 0.7),
        child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(
                  paramController.fakeLatitude.value,
                  paramController.fakeLongitude
                      .value), //LatLng(, paramController.fakeLongitude.value),
              initialZoom: 16,
              onMapReady: () {
                // controller.mapController = mapController;
              },
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && mounted) {
                  setState(() {
                    followUser = false;
                  });
                }
              },
              onTap: (tapPosition, point) {
                // Reset the polygons when clicking anywhere on the map

                if (mounted) {
                  setState(() {
                    _hoverGons = null;
                    _prevHitValues = null;
                  });
                }
              },
            ),
            children: [
              Text("${paramController.fakeLatitude.value}"),
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN']!,
                  'id': 'mapbox.satellite',
                },
              ),
              MouseRegion(
                hitTestBehavior: HitTestBehavior.deferToChild,
                cursor: SystemMouseCursors.click,
                onHover: (_) {
                  final hitValues = _hitNotifier.value?.hitValues.toList();
                  if (hitValues == null) {
                    return;
                  }

                  if (listEquals(hitValues, _prevHitValues)) return;
                  _prevHitValues = hitValues;

                  var polygons = Map.fromEntries(
                      drawnPolygons.map((e) => MapEntry(e.hitValue, e)));

                  final hoverLines = hitValues.map((v) {
                    final original = polygons[v]!;

                    return Polygon<HitValue>(
                      points: original.points,
                      holePointsList: original.holePointsList,
                      color: Colors.transparent,
                      borderStrokeWidth: 15,
                      borderColor: Colors.green,
                      disableHolesBorder: original.disableHolesBorder,
                    );
                  }).toList();
                  if (mounted) {
                    setState(() => _hoverGons = hoverLines);
                  }
                },
                onExit: (_) {
                  if (mounted) {
                    setState(() {
                      _hoverGons = null;
                      _prevHitValues = null;
                    });
                  }
                },
                child: GestureDetector(
                  // onTap: () => _openTouchedGonsModal(
                  //   'Tapped',
                  //   _hitNotifier.value!.hitValues,
                  //   _hitNotifier.value!.coordinate,
                  // ),
                  child: Stack(children: [
                    PolylineLayer(
                      hitNotifier: _hitNotifier,
                      polylines: [...drawnPolylines],
                      simplificationTolerance: 0,
                    ),
                    PolygonLayer(
                      hitNotifier: _hitNotifier,
                      simplificationTolerance: 0,
                      polygons: [...drawnPolygons, ...?_hoverGons],
                    ),
                    MarkerLayer(
                      markers: getMarkerList(),
                      rotate: true,
                    ),
                  ]),
                ),
              )
            ]),
      ),
    );
  }

  void _openTouchedGonsModal(
    String eventType,
    List<HitValue> tappedLines,
    LatLng coords,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TIM Message',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   '$eventType at point: (${coords.latitude.toStringAsFixed(6)}, ${coords.longitude.toStringAsFixed(6)})',
            // ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final tappedLineData = tappedLines[index];
                  TravelerDataFrame frame = tappedLineData.frame;
                  return FutureBuilder<ItisCode>(
                      future: timManager.getItisRepresentationForDataFrame(
                          tappedLineData.frame),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator while waiting for the async call
                          return const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text("Loading..."),
                          );
                        } else if (snapshot.hasError) {
                          // Handle any errors that occurred during the async call
                          return ListTile(
                            leading: const Icon(Icons.error),
                            title: const Text("Error loading data"),
                            subtitle: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          // Show the actual data once it has been fetched
                          final ItisCode code = snapshot.data!;
                          return ListTile(
                            leading: index == 0
                                ? code.image != null
                                    ? Image(image: code.image!)
                                    : Text(code.description,
                                        style: const TextStyle(fontSize: 16.0))
                                : index == tappedLines.length - 1
                                    ? const Icon(Icons.vertical_align_bottom)
                                    : const SizedBox.shrink(),
                            title: const Text("TIM Message"),
                            subtitle: Text(
                                "Description: ${code.description}\nStart Time: ${timManager.getTimStartTime(frame)}\n End Time: ${timManager.getTimEndTime(frame)}"),
                            dense: false,
                          );
                        }
                        // Default case: show nothing if there’s no data
                        return const SizedBox.shrink();
                      });
                },
                itemCount: tappedLines.length,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (mounted) {
                      setState(() {
                        _hoverGons = null;
                        _prevHitValues = null;
                      });
                    }
                  },
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
