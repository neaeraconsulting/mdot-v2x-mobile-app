import 'package:cv_mec/models/J2735/AccelerationSet4Way.dart';
import 'package:cv_mec/models/J2735/BrakeSystemStatus.dart';
import 'package:cv_mec/models/J2735/DSecond.dart';
import 'package:cv_mec/models/J2735/Elevation.dart';
import 'package:cv_mec/models/J2735/Heading.dart';
import 'package:cv_mec/models/J2735/Latitude.dart';
import 'package:cv_mec/models/J2735/Longitude.dart';
import 'package:cv_mec/models/J2735/MsgCount.dart';
import 'package:cv_mec/models/J2735/PositionalAccuracy.dart';
import 'package:cv_mec/models/J2735/Speed.dart';
import 'package:cv_mec/models/J2735/SteeringWheelAngle.dart';
import 'package:cv_mec/models/J2735/TemporaryID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/TransmissionState.dart';
import 'package:cv_mec/models/J2735/VehicleSize.dart';

class BSMcoreData {
  late MsgCount msgCnt;
  late TemporaryID id;
  late DSecond secMark;
  late Latitude lat;
  late Longitude long;
  late Elevation elev;
  late PositionalAccuracy accuracy;
  late TransmissionState transmission;
  late Speed speed;
  late Heading heading;
  late SteeringWheelAngle angle;
  late AccelerationSet4Way accelSet;
  late BrakeSystemStatus brakes;
  late VehicleSize size;

  BSMcoreData.fromC(C.BSMcoreData bsmCoreData){
    msgCnt = MsgCount(bsmCoreData.msgCnt);
    id = TemporaryID.fromOctetString(bsmCoreData.id);
    secMark = DSecond(bsmCoreData.secMark);
    lat = Latitude(bsmCoreData.lat);
    long = Longitude(bsmCoreData.Long);
    elev = Elevation(bsmCoreData.elev);
    accuracy = PositionalAccuracy.fromC(bsmCoreData.accuracy);
    transmission = TransmissionState.values[bsmCoreData.transmission];
    speed = Speed(bsmCoreData.speed);
    heading = Heading(bsmCoreData.heading);
    angle = SteeringWheelAngle(bsmCoreData.angle);
    accelSet = AccelerationSet4Way.fromC(bsmCoreData.accelSet);
    brakes = BrakeSystemStatus.fromC(bsmCoreData.brakes);
    size = VehicleSize.fromC(bsmCoreData.size);
  }


  void toC(C.BSMcoreData bsmCoreData){
    bsmCoreData.msgCnt = msgCnt.msgCount;
    id.toOctetString(bsmCoreData.id);
    bsmCoreData.secMark = secMark.dSecond;
    bsmCoreData.lat = lat.latitude;
    bsmCoreData.Long = long.longitude;


  }
}