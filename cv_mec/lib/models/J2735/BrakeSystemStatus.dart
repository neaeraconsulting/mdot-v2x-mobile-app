import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/AntiLockBrakeStatus.dart';
import 'package:cv_mec/models/J2735/AuxiliaryBrakeStatus.dart';
import 'package:cv_mec/models/J2735/BrakeAppliedStatus.dart';
import 'package:cv_mec/models/J2735/BrakeBoostApplied.dart';
import 'package:cv_mec/models/J2735/StabilityControlStatus.dart';
import 'package:cv_mec/models/J2735/TractionControlStatus.dart';

class BrakeSystemStatus {

  late BrakeAppliedStatus wheelBrakes;
  late TractionControlStatus traction;
  late AntiLockBrakeStatus abs;
  late StabilityControlStatus scs;
  late BrakeBoostApplied brakeBoost;
  late AuxiliaryBrakeStatus auxBrakes;


  BrakeSystemStatus.fromC(C.BrakeSystemStatus brakeSystemStatus){
    wheelBrakes = BrakeAppliedStatus.fromBitString(brakeSystemStatus.wheelBrakes);
    traction = TractionControlStatus.values[brakeSystemStatus.traction];
    abs = AntiLockBrakeStatus.values[brakeSystemStatus.abs];
    scs = StabilityControlStatus.values[brakeSystemStatus.scs];
    brakeBoost = BrakeBoostApplied.values[brakeSystemStatus.brakeBoost];
    auxBrakes = AuxiliaryBrakeStatus.values[brakeSystemStatus.auxBrakes];
  }

}