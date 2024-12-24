import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/acceleration.dart';
import 'package:cv_mec/models/j2735/vertical_acceleration.dart';
import 'package:cv_mec/models/j2735/yaw_rate.dart';

class AccelerationSet4Way {
  late Acceleration long;
  late Acceleration lat;
  late VerticalAcceleration vert;
  late YawRate yaw;

  AccelerationSet4Way.fromC(C.AccelerationSet4Way accelerationSet4Way) {
    long = Acceleration(accelerationSet4Way.Long);
    lat = Acceleration(accelerationSet4Way.lat);
    vert = VerticalAcceleration(accelerationSet4Way.vert);
    yaw = YawRate(accelerationSet4Way.yaw);
  }
}
