import 'package:cv_mec/models/j2735/acceleration_set_4_way.dart';
import 'package:cv_mec/models/j2735/brake_system_status.dart';
import 'package:cv_mec/models/j2735/d_second.dart';
import 'package:cv_mec/models/j2735/elevation.dart';
import 'package:cv_mec/models/j2735/heading.dart';
import 'package:cv_mec/models/j2735/Latitude.dart';
import 'package:cv_mec/models/j2735/Longitude.dart';
import 'package:cv_mec/models/j2735/msg_count.dart';
import 'package:cv_mec/models/j2735/positional_accuracy.dart';
import 'package:cv_mec/models/j2735/speed.dart';
import 'package:cv_mec/models/j2735/steering_wheel_angle.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/temporary_id.dart';
import 'package:cv_mec/models/j2735/transmission_state.dart';
import 'package:cv_mec/models/j2735/vehicle_size.dart';

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

  BSMcoreData.fromC(C.BSMcoreData bsmCoreData) {
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

  void toC(C.BSMcoreData bsmCoreData) {
    bsmCoreData.msgCnt = msgCnt.msgCount;
    id.toOctetString(bsmCoreData.id);
    bsmCoreData.secMark = secMark.dSecond;
    bsmCoreData.lat = lat.latitude;
    bsmCoreData.Long = long.longitude;
  }
}
