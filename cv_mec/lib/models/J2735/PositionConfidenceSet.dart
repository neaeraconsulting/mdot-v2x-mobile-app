import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/ElevationConfidence.dart';
import 'package:cv_mec/models/J2735/PositionConfidence.dart';

class PositionConfidenceSet {
  late PositionConfidence pos;
  late ElevationConfidence elevation;

  PositionConfidenceSet.fromC(C.PositionConfidenceSet c_positionConfidenceSet){
    pos = PositionConfidence.values[c_positionConfidenceSet.pos];
    elevation = ElevationConfidence.values[c_positionConfidenceSet.elevation];
  }
}