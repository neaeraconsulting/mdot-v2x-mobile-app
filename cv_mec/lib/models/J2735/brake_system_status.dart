import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/anti_lock_brake_status.dart';
import 'package:cv_mec/models/j2735/auxiliary_brake_status.dart';
import 'package:cv_mec/models/j2735/brake_applied_status.dart';
import 'package:cv_mec/models/j2735/brake_boost_applied.dart';
import 'package:cv_mec/models/j2735/stability_control_status.dart';
import 'package:cv_mec/models/j2735/traction_control_status.dart';

class BrakeSystemStatus {
  late BrakeAppliedStatus wheelBrakes;
  late TractionControlStatus traction;
  late AntiLockBrakeStatus abs;
  late StabilityControlStatus scs;
  late BrakeBoostApplied brakeBoost;
  late AuxiliaryBrakeStatus auxBrakes;

  BrakeSystemStatus.fromC(C.BrakeSystemStatus brakeSystemStatus) {
    wheelBrakes =
        BrakeAppliedStatus.fromBitString(brakeSystemStatus.wheelBrakes);
    traction = TractionControlStatus.values[brakeSystemStatus.traction];
    abs = AntiLockBrakeStatus.values[brakeSystemStatus.abs];
    scs = StabilityControlStatus.values[brakeSystemStatus.scs];
    brakeBoost = BrakeBoostApplied.values[brakeSystemStatus.brakeBoost];
    auxBrakes = AuxiliaryBrakeStatus.values[brakeSystemStatus.auxBrakes];
  }
}
