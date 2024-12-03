import 'dart:ffi';

import 'package:cv_mec/models/J2735/J2735.dart';
import 'package:cv_mec/models/J2735/RoadRegulatorID.dart';
import 'package:cv_mec/models/J2735/RoadSegmentID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class RoadSegmentReferenceID {
  late RoadRegulatorID? region;
  late RoadSegmentID id;

  RoadSegmentReferenceID.fromC(C.RoadSegmentReferenceID roadSegmentReferenceID){
    if(roadSegmentReferenceID.region.address != 0){
      region = RoadRegulatorID(roadSegmentReferenceID.region.value);
    }

    id = RoadSegmentID(roadSegmentReferenceID.id);
  }
}