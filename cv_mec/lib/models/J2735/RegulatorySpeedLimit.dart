import 'package:asn1_plugin/generated_bindings.dart' as C;

import 'package:cv_mec/models/J2735/SpeedLimitType.dart';
import 'package:cv_mec/models/J2735/Velocity.dart';

class RegulatorySpeedLimit {

  late SpeedLimitType type;
  late Velocity speed;

  RegulatorySpeedLimit.fromC(C.RegulatorySpeedLimit regulatorySpeedLimit){
    type = SpeedLimitType.values[regulatorySpeedLimit.type];
    speed = Velocity(regulatorySpeedLimit.speed);

  }

}