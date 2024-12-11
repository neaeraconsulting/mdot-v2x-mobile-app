import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:connection_network_type/connection_network_type.dart';
import 'package:cv_mec/models/GeometryDirection.dart';
import 'package:cv_mec/models/J2735/TravelerDataFrame.dart';
import 'package:cv_mec/models/J2735/TravelerInformation.dart';
import 'package:cv_mec/models/MsgTypes.dart';
import 'package:cv_mec/models/dataFrameGeometry.dart';
import 'package:cv_mec/models/dataQueue.dart';
import 'package:cv_mec/models/itisCode.dart';
import 'package:cv_mec/models/itisParser.dart';
import 'package:cv_mec/models/receievedBsm.dart';
import 'package:cv_mec/models/registration.dart';
import 'package:cv_mec/models/tim_manager.dart';
import 'package:cv_mec/models/utils.dart';
import 'package:cv_mec/pages/mqtt_page.dart';
import 'package:cv_mec/services/api_service.dart';
import 'package:cv_mec/services/asn_service.dart';
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
import 'package:cv_mec/services/param_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:cv_mec/models/geoRoutedMsg.pb.dart' as protobuf;
import 'package:permission_handler/permission_handler.dart';
import 'package:typed_data/typed_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:telephony/telephony.dart';


// import 'package:flutter/foundation.dart';

typedef HitValue = ({TravelerDataFrame frame});

enum ConnectedStatus {
  UNKNOWN, DISCONNECTED, CONNECTED, PARTIAl
}

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
  Telephony telephony = Telephony.instance;
  SettingsController settingsController = Get.find<SettingsController>();

  TimManager timManager = TimManager();

  Registration? registration;
  String? mqttConnectionURL;
  Position? currentPosition;

  late String publishTopic;
  late String subscribeTopic;

  Timer? bsmMessageTimer;
  late Pointer<Pointer<Void>> bsmTemplate;

  Color connectedButtonColor = Colors.red;
  StreamSubscription<Position>? positionStream;

  Map<String, ReceivedBsm> receivedBsms = {};

  List<ItisCode> showTims = [];
  List<Polygon<HitValue>> nearbyTimPolygons = [];

  bool followUser = true;

  

  late File recLogFile;
  late File sendLogFile;
  late File appLogFile;
  late File timLogFile;

  late DataQueue recDataQueue;
  late DataQueue pubDataQueue;
  late DataQueue appLogQueue;
  late DataQueue timDataQueue;


  final LayerHitNotifier<HitValue> _hitNotifier = ValueNotifier(null);
  List<HitValue>? _prevHitValues;
  List<Polygon<HitValue>>? _hoverGons;

  bool debugMode = false;
  bool showLoadingIcon = true;


  @override
  void initState() {
    super.initState();
    showLoadingIcon = true;
    _mapController = MapController();
    timingService.startAllUpdates();
    bsmTemplate = asnService.decode(asnService.bsmTemplate);
    asnService.randomizeBsmId(bsmTemplate);

    publishTopic = "vzimp/1/GeoRelevance/${paramController.clientType.value}/${paramController.clientSubtype.value}/Public/${paramController.messageFormat}/BSM";
    subscribeTopic = "vzimp/1/GeoRelevance/+/+/Public/${paramController.messageFormat}/+/+";


    if(debugMode){
      // TravelerInformation tim = asnService.decodeTim(asnService.shopTestTim);
      // timManager.addOrUpdate(tim, asnService.shopTestTim);

      // TravelerInformation tim2 = asnService.decodeTim(asnService.snowTim);
      // timManager.addOrUpdate(tim2, asnService.snowTim);

      // TravelerInformation tim3 = asnService.decodeTim(asnService.longQueueTim);
      // timManager.addOrUpdate(tim3, asnService.queueTim);
      TravelerInformation tim4 = asnService.decodeTim(asnService.testTimTemplate);
      timManager.addOrUpdate(tim4, asnService.testTimTemplate);
    }
    
    


    Future.delayed(Duration.zero,() async {
      if (Platform.isAndroid) {
        await Permission.phone.request();
        await telephony.requestPhoneAndSmsPermissions;
      }

      int loggingEnabled = await enableLogging();
      if(loggingEnabled != 0){
        return;
      }

      int connected = await connectToMqttBroker();
      if(connected != 0){
        return;
      }

      updateConnectedStatus(ConnectedStatus.CONNECTED);

      if(debugMode){
        positionStream = fakePosition().listen(updatePosition);
      }else{
        positionStream = locationService.locationStream.listen(updatePosition);
      }

    });
    
    setState(() {
      nearbyTimPolygons =  getPolygons();
      showLoadingIcon = true;
    });
    
  }

  Stream<Position> fakePosition() {
    List<List<double>> fakePosition = [
      [-104.6561595418617,41.15345216754946],
      [-104.6573927335249,41.15341401495245],
      [-104.6590666532654,41.15306277390567],
      [-104.6605730477014,41.15257914872963],
      [-104.6617224952236,41.15207357286492],
      [-104.6625679341257,41.15150191309434],
      [-104.6636372553181,41.15047071929914],
      [-104.6639320455159,41.1501370073646],
      [-104.6638033877887,41.14984785653078],
      [-104.6636150594618,41.14941052090466],
      [-104.663271970029,41.14890607348637],
      [-104.6628507704041,41.14856439867128],
      [-104.6622610668666,41.14824505010286],
      [-104.6616313568971,41.14794061416405],
      [-104.6607662341223,41.14763559697753],
      [-104.6599988871735,41.14740480440657],
      [-104.6592008284514,41.147241238102],
      [-104.6583241116581,41.147129395734],
      [-104.6570632588503,41.14699448483902],
      [-104.6552592676835,41.14694044027667],
      [-104.6540259592636,41.14701322706684],
      [-104.6523573470199,41.14710164841533],
      [-104.650549640959,41.14737584424974],
      [-104.6491843566055,41.14770129169258],
      [-104.6476816917767,41.14811759634699],
      [-104.6465303616881,41.14864429693967],
      [-104.6455066268323,41.14929856692202],
      [-104.6446225006321,41.14996155822642],
      [-104.6443390355551,41.15057279143712],
      [-104.6441157220364,41.15082607720087],
      [-104.6442588765848,41.15106483139488],
      [-104.6445017890072,41.15160904210572],
      [-104.644812537398,41.15201861177719],
      [-104.6453890544243,41.15234617409661],
      [-104.6462181227486,41.15275649556694],
      [-104.6470648326806,41.15309347289094],
      [-104.6479243278075,41.15334819821749],
      [-104.6488473404503,41.15354120482534],
      [-104.6498488108498,41.1537194168705],
      [-104.6511867637169,41.15379243827938],
      [-104.6524637782885,41.15381393338678],
      [-104.6534036986443,41.15379780527977],
      [-104.6541749127448,41.1537225075805],
      [-104.6551333675142,41.15359518913309],
      [-104.6557902765014,41.1533760979494],
      [-104.655941569777,41.1533844572879],
      [-104.65593194674,41.153331099475],
      [-104.6558537273296,41.15311864411694],
      [-104.6558313168253,41.15289878635123],
      [-104.6557839266243,41.1527341177344],
      [-104.6558010405442,41.15255634354074],
      [-104.6558139018388,41.15231574851319],
      [-104.6559084365072,41.15210233350017],
      [-104.6560162960262,41.15179024621532],
      [-104.6562069594552,41.15142387531776],
      [-104.6564577671106,41.15111016412518],
      [-104.6566945913634,41.15086021457106],
      [-104.6569173782721,41.15059351635055],
      [-104.6571205636599,41.15037523813064],
      [-104.6572902489951,41.15020455921358],
      [-104.6574763055333,41.1499586423374],
      [-104.6576492316124,41.14978254668777],
      [-104.6577991961617,41.14958305299309],
      [-104.6579506126636,41.14942512600238],
      [-104.6581009489405,41.14916947868519],
      [-104.6581009489405,41.14906947868519],
      [-104.6581009489405,41.14896947868519],
      [-104.6581009489405,41.14906947868519],
      [-104.6578877569632,41.14939765264025],
      [-104.6577502874676,41.14956920548699],
      [-104.6575940913711,41.14974727676776],
      [-104.6574249460533,41.14990910810871],
      [-104.6572131460098,41.15018943276315],
      [-104.6570697531772,41.15034907789568],
      [-104.6568574287179,41.15056725635974],
      [-104.6566389173078,41.15084077820019],
      [-104.6564204296445,41.151098347479],
      [-104.6561598158793,41.15143095589855],
      [-104.6559782429146,41.15176947193908],
      [-104.6558697945301,41.15210148383645],
      [-104.6557850165821,41.15229444935622],
      [-104.6557717113443,41.15254674138579],
      [-104.655744534182,41.15272481454229],
      [-104.6557171621404,41.15289322596242],
      [-104.6557033114764,41.15313575383042],
      [-104.6556386502736,41.15338428781476],
      [-104.6557902765014,41.1533760979494],

    ];

    return Stream<Position>.periodic(Duration(milliseconds: 500), (count){
      int index = count % fakePosition.length;
      int prevIndex = (count - 1)% fakePosition.length;

      List<double> pos = fakePosition[index];
      List<double> lastPos = fakePosition[prevIndex];

      double heading = radianToDeg(atan2(pos[1] - lastPos[1], pos[0] - lastPos[0]));

      heading = -heading + 90;
      if(heading < 0){
        heading += 360;
      }
      return Position(longitude: fakePosition[index][0], latitude: fakePosition[index][1], timestamp: DateTime.now(), accuracy: 0, altitude: 1600, altitudeAccuracy: 0, heading: heading, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
    });
  }

  Future<int> enableLogging() async {
    DateTime logTime = timingService.getKronosTime();

    recLogFile = await fileService.getFileForWriting(
          "MQTT_SUB_LOG_${logTime.millisecondsSinceEpoch}.csv");
    sendLogFile = await fileService.getFileForWriting(
          "MQTT_PUB_LOG_${logTime.millisecondsSinceEpoch}.csv");
    appLogFile = await fileService.getFileForWriting(
          "APP_LOG_${logTime.millisecondsSinceEpoch}.log");
    timLogFile = await fileService.getFileForWriting(
          "TIM_LOG_${logTime.millisecondsSinceEpoch}.csv");

    recDataQueue = DataQueue(recLogFile);
    pubDataQueue = DataQueue(sendLogFile);
    appLogQueue = DataQueue(appLogFile);
    timDataQueue = DataQueue(timLogFile);


    String subHeader = "Topic, Receive Time ms, Send Time ms, Delta Time ms, Longitude, Latitude, Network, Broker, Msg Bytes\n";
    String pubHeader = "Topic, Send Time ms, Longitude, Latitude, Network, Broker, Msg Bytes\n";
    String timHeader = "Action, Time, Longitude, Latitude, Heading, asn1\n";
      

    recDataQueue.addItem(subHeader);
    pubDataQueue.addItem(pubHeader);
    timDataQueue.addItem(timHeader);

    return 0;
  }

  Future<int> connectToMqttBroker() async {
    String? token = await apiService.getToken();

    setState(() {
      showLoadingIcon = true;
    });

    updateConnectedStatus(ConnectedStatus.PARTIAl);

    if (token == null) {
      showError("Unable to retrieve token from partner API. Please verify partner API credentials in settings menu");
      return 1;
    }

    //Add Loading Registration from Cache
    if (await fileService.checkIfRegistrationExists()) {
      addToAppLog("Loading Registration from Cache");
      registration = await fileService.getRegistration();

    } else {
      addToAppLog("Loading Registration from Server");
      registration = await apiService.getRegistration(token, paramController.clientType.value, paramController.clientSubtype.value);
      fileService.saveRegistration(registration!);
    }
    
    if(registration == null){
      showError("Unable to retrieve registration information from partner API");
      return 2;
    }

    
    addToAppLog("Acquired Certificates for DeviceID: ${registration!.deviceID}");

    String vzString = paramController.networkType.value;

    if(settingsController.vzMode.value){
      vzString = "VZ";
    }else{
      vzString = "non-VZ";
    }

    mqttConnectionURL = await apiService.getConnection(
        token,
        registration!.deviceID,
        paramController.fakeLatitude.value,
        paramController.fakeLongitude.value,
        vzString);

    int result = await mqtt.connect(mqttConnectionURL!, registration!);
    if(result != 0){
      showError("Unable to Connect to MQTT Broker");
      return 3;
    }

    mqtt.subscribe(subscribeTopic, onGeoRelevanceMessage);

    startSendingBSM();

    setState(() {
      showLoadingIcon = false;
    });
    
    return 0;
  }

  

  void onGeoRelevanceMessage(MqttReceivedMessage<MqttMessage?> message, DateTime recTime) async{
    addToAppLog("Received Geo Relevance Message");

    final recMess = message.payload as MqttPublishMessage;

    protobuf.GeoRoutedMsg decodedMessage =
        protobuf.GeoRoutedMsg.fromBuffer(recMess.payload.message);

    DateTime msgTime = Utils.timeStampToDateTime(decodedMessage.time);

    

    String hex = utf8.decode(decodedMessage.msgBytes);


    MsgType msgType = asnService.determineHexMessageType(hex);


    if(msgType == MsgType.BSM){
      addToAppLog("Identified Message as BSM");
      Pointer<Pointer<Void>> bsm = asnService.decode(hex);
      LatLng position = LatLng(decodedMessage.position.latitude, decodedMessage.position.longitude);
      String vehicleID = asnService.getBsmId(bsm);

      

      if(receivedBsms.containsKey(vehicleID)){
        
        if(receivedBsms[vehicleID]!.dateTime.isBefore(msgTime)){
          receivedBsms[vehicleID] = ReceivedBsm(vehicleID, msgTime, position);
        }
      }else{
        receivedBsms[vehicleID] = ReceivedBsm(vehicleID, msgTime, position);
      }

      asnService.cleanupDecoded(bsm);
      
      
    }else if(msgType == MsgType.TIM){
      addToAppLog("Identified Message as TIM");
      String trimmedHex = asnService.trimMessageHeaders(hex, asnService.TIM_START_FLAG)!;
      TravelerInformation tim = asnService.decodeTim(trimmedHex);
      addToTimLog("RECEIVED", hex);

      timManager.addOrUpdate(tim, hex);
      setState(() {
        nearbyTimPolygons = getPolygons();
      });
      
    }

    String netStat = "Unavailable";
    if (Platform.isAndroid) {
      netStat = await getNetworkField();
    }
    String record =
        "${message.topic},${recTime.millisecondsSinceEpoch},${msgTime.millisecondsSinceEpoch},${recTime.millisecondsSinceEpoch - msgTime.millisecondsSinceEpoch},${decodedMessage.position.longitude},${decodedMessage.position.latitude},$netStat,$mqttConnectionURL,${utf8.decode(decodedMessage.msgBytes)}\n";

    recDataQueue.addItem(record);
    
  }

  void showError(String message){
    addToAppLog("ERROR: $message");
    // TODO
  }

  void addToAppLog(String message){
    // TODO
    print(message);
    appLogQueue.addItem("$message\n");
  }

  void startSendingBSM() {
    // Stop any previous timer
    bsmMessageTimer?.cancel();

    // Set the timer to call _runFunction every 100 milliseconds
    bsmMessageTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      sendBsm();
      if (!isConnected()) {
        stopSendingBSM();
        onMqttDisconnect();
      }
    });
  }

  void sendBsm() async {
      protobuf.GeoRoutedMsg msg = protobuf.GeoRoutedMsg();

      protobuf.Position pos = protobuf.Position();

      if(currentPosition==null){
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

      msg.msgBytes = utf8.encode(asnService.encode(bsmTemplate));
      msg.time = Utils.dateTimeToTimestamp(sendTime);

      buffer.addAll(msg.writeToBuffer());

      int messageID = mqtt.publishBytes(buffer, publishTopic);
      updateConnectedStatus(ConnectedStatus.CONNECTED);
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

  void stopSendingBSM() {
    bsmMessageTimer?.cancel();
  }

  Future<void> updatePosition(Position position) async {
    currentPosition = position;

    setState(() {
      nearbyTimPolygons = getPolygons();
    });
    

    if(followUser){
      _mapController.moveAndRotate(getUserLocation(), _mapController.camera.zoom, _mapController.camera.rotation);
    }
    
    List<TravelerDataFrame> newActiveTims =  timManager.getNewActiveTims(position.longitude, position.latitude, position.heading);

    // List<TravelerDataFrame> frames = timManager.getTimsToShow(-104.9695, 40.4741, position.heading);
    List<TravelerDataFrame> frames = timManager.getTimsToShow(position.longitude, position.latitude, position.heading);
    List<ItisCode> codes = await timManager.getItisRepresentationForDataFrames(frames);


    List<String> hex = timManager.getUniqueAsnFromDataFrames(frames);
    for(String str in hex){
      addToTimLog("ALERT", str);
    }
    



    setState(() {
      showTims = codes;
    });
    
    // showTimMessage(newActiveTims);

  }

  void onMqttDisconnect(){
    showError("Disconnected from MQTT Broker Randomly");
    updateConnectedStatus(ConnectedStatus.DISCONNECTED);
    stopSendingBSM();
    //TODO cleanup other tasks
  }

  bool isConnected() {
    return mqtt.client != null &&
        mqtt.client!.connectionStatus!.state == MqttConnectionState.connected;
  }

  LatLng getUserLocation(){
    if(currentPosition != null){
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }else{
      return LatLng(paramController.fakeLatitude.value, paramController.fakeLongitude.value);
    }                       
  }

  void updateConnectedStatus(ConnectedStatus status){
    print("Updating Connected Status");
    setState(() {
      if(status == ConnectedStatus.UNKNOWN){
        connectedButtonColor = Colors.grey;
      }else if(status == ConnectedStatus.CONNECTED){
        connectedButtonColor = Colors.green;
      }else if (status == ConnectedStatus.DISCONNECTED){
        connectedButtonColor = Colors.red;
      }else if(status == ConnectedStatus.PARTIAl){
        connectedButtonColor = Colors.orange;
      }
    });
  }

  List<Marker> getMarkerList(){

    List<Marker> markerList = [];

    
    if(currentPosition != null){
        Marker userMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: getUserLocation(),
        child: Icon(Icons.directions_car, color: Colors.red,)
        ,
      );

      markerList.add(userMarker);
    }
    

    DateTime compTime = timingService.getKronosTime();
    DateTime endTime = compTime.add(Duration(seconds: 1));
    DateTime startTime = compTime.subtract(Duration(seconds: 1));

    List<String> removeKeys = [];
    
    for(String key in receivedBsms.keys){
      ReceivedBsm bsm = receivedBsms[key]!;
      if(bsm.dateTime.toUtc().isAfter(startTime) && bsm.dateTime.toUtc().isBefore(endTime)){

        Marker remoteMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: bsm.position,
          child: Icon(Icons.directions_car, color:Colors.blue[900]),
        );


        markerList.add(remoteMarker);
      }else{
        removeKeys.add(key);
      }
    }

    for(String key in removeKeys){
      receivedBsms.remove(key);
    }

    return markerList;
  }

  List<Polygon<HitValue>> getPolygons(){
    List<Polygon<HitValue>> polygons = [];

    List<DataFrameGeometry> dataFrames = timManager.getActiveTimGeometry();

    for(DataFrameGeometry frame in dataFrames){

      TravelerDataFrame tdFrame = frame.frame;

      // ItisCode code = await timManager.getItisRepresentationForDataFrame(tdFrame);

      for(GeometryDirection geoDir in frame.geometry){
        List<LatLng> polyPoints = geometryService.convertGeometryToLatLngList(geoDir.geometry);

        

        Polygon<HitValue> hitPoly = Polygon(
          points: polyPoints,
          borderColor: Colors.orangeAccent,
          color: Color.fromARGB(128, 252, 173, 89),
          borderStrokeWidth: 1,
          hitValue: (
            frame: tdFrame,
          ),  
        );

        polygons.add(hitPoly);
      }

    }

    return polygons;
  }

  addToTimLog(String action, String asn1){
    if(currentPosition!=null){
      timDataQueue.addItem("$action, ${timingService.getKronosTime().millisecondsSinceEpoch}, ${currentPosition!.longitude}, ${currentPosition!.latitude}, ${currentPosition!.heading}, $asn1\n");
    }else{
      timDataQueue.addItem("$action, ${timingService.getKronosTime().millisecondsSinceEpoch}, 0, 0, 0, $asn1\n");
    }
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


  @override
  Widget build(BuildContext context) {
    const String appTitle = "MAP";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              bsmMessageTimer?.cancel();
              positionStream?.cancel();
              mqtt.disconnect();

              Future.delayed(Duration(milliseconds: 100),() async {
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
      body: Stack(alignment: AlignmentDirectional.topStart, 
        children: [
          Center(
            child: map(context, _mapController)
          ),
          Align(alignment: Alignment.topLeft,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateConnectedStatus(ConnectedStatus.DISCONNECTED);
                    stopSendingBSM();
                    connectToMqttBroker();
                  },
                  // child: Icon(Icons.menu, color: Colors.white),
                  child: Icon(Icons.connect_without_contact_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: connectedButtonColor, // <-- Button color
                    foregroundColor: Colors.black, // <-- Splash color
                    shadowColor: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    followUser = true;
                    _mapController.moveAndRotate(getUserLocation(), _mapController.camera.zoom, _mapController.camera.rotation);
                  },
                  // child: Icon(Icons.menu, color: Colors.white),
                  child: Icon(Icons.directions_car, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: followUser ? Colors.green : Colors.blue, // <-- Button color
                    foregroundColor: Colors.black, // <-- Splash color
                    shadowColor: Colors.black,
                  ),
                ),
              ]
            )
          ),
          Align(alignment: Alignment.bottomCenter,
            child: CarouselSlider(
              options: CarouselOptions(height: 150.0, viewportFraction: 0.3, enableInfiniteScroll: false),
              items: showTims.map((displayCode) {

                Color borderColor = Colors.blue;

                if(displayCode.status == ITIS_CODE_STATUS.VALID){
                  borderColor = Colors.green;
                }else if(displayCode.status ==ITIS_CODE_STATUS.UNKNOWN){
                  borderColor = Colors.yellow;
                }else if(displayCode.status == ITIS_CODE_STATUS.ERROR){
                  borderColor = Colors.red;
                }

                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: displayCode.image != null ? Image(image: displayCode.image!) : Text('${displayCode.description}', style: TextStyle(fontSize: 16.0),)
                    );
                  },
                );
              }).toList(),
            )
          ),
          Align(alignment:Alignment.center, 
            child: showLoadingIcon? const SpinKitSpinningLines(color: Colors.white, size: 140, lineWidth: 4,) : null,
          )
        ]
      ), 
    );   
  }

  Widget map(BuildContext context,  MapController mapController) {
    return Obx(
      () => SizedBox(
        // width: screenWidthPercentage(context, percentage: orientation == Orientation.portrait ? 0.8 : 0.4),
        // height: screenHeightPercentage(context, percentage: orientation == Orientation.portrait ? 0.45 : 0.7),
        child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(paramController.fakeLatitude.value, paramController.fakeLongitude.value),//LatLng(, paramController.fakeLongitude.value),
              initialZoom: 16,
              onMapReady: () {
                // controller.mapController = mapController;
              },
              onPositionChanged: (position, hasGesture){
                if (hasGesture) {
                    setState(() {
                      followUser = false;
                    });
                  }
              },
              onTap: (tapPosition, point) {
                // Reset the polygons when clicking anywhere on the map
                setState(() {
                  _hoverGons = null;
                  _prevHitValues = null;
                });
              },
            ),
            children: [
              Text("${paramController.fakeLatitude.value}"),
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN']!,
                  'id': 'mapbox.satellite',
                },
              ),
              MarkerLayer(
                  markers: getMarkerList(),
                  rotate: true,
                ),
              MouseRegion(
                hitTestBehavior: HitTestBehavior.deferToChild,
                cursor: SystemMouseCursors.click,
                onHover: (_) {

                  final hitValues = _hitNotifier.value?.hitValues.toList();
                  if (hitValues == null){
                    return;
                  }

                  if (listEquals(hitValues, _prevHitValues)) return;
                  _prevHitValues = hitValues;

                  var _polygons = Map.fromEntries(nearbyTimPolygons.map((e) => MapEntry(e.hitValue, e)));

                  final hoverLines = hitValues.map((v) {

                    
                    final original = _polygons[v]!;

                    return Polygon<HitValue>(
                      points: original.points,
                      holePointsList: original.holePointsList,
                      color: Colors.transparent,
                      borderStrokeWidth: 15,
                      borderColor: Colors.green,
                      disableHolesBorder: original.disableHolesBorder,
                    );
                  }).toList();
                  setState(() => _hoverGons = hoverLines);
                },
                onExit: (_) {
                  setState(() {
                    _hoverGons = null;
                    _prevHitValues = null;
                  });
                },
                child: GestureDetector(
                  onTap: () => _openTouchedGonsModal(
                    'Tapped',
                    _hitNotifier.value!.hitValues,
                    _hitNotifier.value!.coordinate,
                  ),
                  child: PolygonLayer(
                    hitNotifier: _hitNotifier,
                    simplificationTolerance: 0,
                    polygons: [...nearbyTimPolygons, ...?_hoverGons],
                  ),
                ),
              ),
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
                  return FutureBuilder<ItisCode> (
                    future: timManager.getItisRepresentationForDataFrame(tappedLineData.frame),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while waiting for the async call
                        return ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text("Loading..."),
                        );
                      } else if (snapshot.hasError) {
                        // Handle any errors that occurred during the async call
                        return ListTile(
                          leading: Icon(Icons.error),
                          title: Text("Error loading data"),
                          subtitle: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        // Show the actual data once it has been fetched
                        final ItisCode code = snapshot.data!;
                        return ListTile(
                          leading: index == 0
                              ? code.image != null
                                  ? Image(image: code.image!)
                                  : Text('${code.description}', style: TextStyle(fontSize: 16.0))
                              : index == tappedLines.length - 1
                                  ? const Icon(Icons.vertical_align_bottom)
                                  : const SizedBox.shrink(),
                          title: Text("TIM Message"),
                          subtitle: Text("Description: ${code.description}\nStart Time: ${timManager.getTimStartTime(frame)}\n End Time: ${timManager.getTimEndTime(frame)}"),
                          dense: false,
                        );
                      }
                      // Default case: show nothing if there’s no data
                      return SizedBox.shrink();
                    }
                  );
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
                  onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                    _hoverGons = null;
                    _prevHitValues = null;
                    });
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

  // @override
  // void dispose(){
  //   super.dispose();
  //   cleanupAll();
    

  // }

  // void cleanupAll(){
  //   stopSendingBSM();
  //   mqtt.disconnect();
  //   _mapController.dispose();
  // }
}
