import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/IntersectionID.dart';
import 'package:cv_mec/models/J2735/RoadRegulatorID.dart';

class IntersectionReferenceID {
  RoadRegulatorID? region;
  late IntersectionID id;

  IntersectionReferenceID.fromC(
      C.IntersectionReferenceID c_intersectionReferenceID) {
    if (c_intersectionReferenceID.region.address != 0) {
      region = RoadRegulatorID(c_intersectionReferenceID.region.value);
    }

    id = IntersectionID(c_intersectionReferenceID.id);
  }

  @override
  bool operator ==(other) {
    // Ignore road regulator ID for now, only match on intersectionID
    return (other is IntersectionReferenceID &&
        other.id.intersectionID == id.intersectionID);
  }
}
