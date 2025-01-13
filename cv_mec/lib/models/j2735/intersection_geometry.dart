import 'dart:ffi';
import 'package:cv_mec/models/j2735/j2735.dart';

import 'package:asn1_plugin/generated_bindings.dart' as C;

class IntersectionGeometry {
  DescriptiveName? name;
  late IntersectionReferenceID id;
  late MsgCount revision;
  late Position3D refPoint;
  LaneWidth? laneWidth;
  SpeedLimitList? speedLimits;
  late LaneList laneSet;
  PreemptPriorityList? preemptPriorityData;

  IntersectionGeometry.fromC(C.IntersectionGeometry c_intersectionGeometry) {
    if (c_intersectionGeometry.name.address != 0) {
      name = DescriptiveName.fromOctetString(c_intersectionGeometry.name.ref);
    }

    id = IntersectionReferenceID.fromC(c_intersectionGeometry.id);

    revision = MsgCount(c_intersectionGeometry.revision);

    refPoint = Position3D.fromC(c_intersectionGeometry.refPoint);

    if (c_intersectionGeometry.laneWidth.address != 0) {
      laneWidth = LaneWidth(c_intersectionGeometry.laneWidth.value);
    }

    if (c_intersectionGeometry.speedLimits.address != 0) {
      speedLimits =
          SpeedLimitList.fromC(c_intersectionGeometry.speedLimits.ref);
    }

    laneSet = LaneList.fromC(c_intersectionGeometry.laneSet);

    if (c_intersectionGeometry.preemptPriorityData.address != 0) {
      preemptPriorityData = PreemptPriorityList.fromC(
          c_intersectionGeometry.preemptPriorityData.ref);
    }
  }
}
