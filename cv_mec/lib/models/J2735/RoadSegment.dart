import 'package:cv_mec/models/J2735/DescriptiveName.dart';
import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/LaneWidth.dart';
import 'package:cv_mec/models/J2735/MsgCount.dart';
import 'package:cv_mec/models/J2735/Position3D.dart';
import 'package:cv_mec/models/J2735/RoadLaneSetList.dart';
import 'package:cv_mec/models/J2735/RoadSegmentReferenceID.dart';
import 'package:cv_mec/models/J2735/SpeedLimitList.dart';

class RoadSegment {
  DescriptiveName? name;
  late RoadSegmentReferenceID id;
  late MsgCount revision;
  late Position3D refPoint;
  LaneWidth? laneWidth;
  SpeedLimitList? speedLimits;
  late RoadLaneSetList roadLaneSet;

  RoadSegment.fromC(C.RoadSegment c_roadSegment) {
    if (c_roadSegment.name.address != 0) {
      name = DescriptiveName.fromOctetString(c_roadSegment.name.ref);
    }

    id = RoadSegmentReferenceID.fromC(c_roadSegment.id);

    revision = MsgCount(c_roadSegment.revision);

    refPoint = Position3D.fromC(c_roadSegment.refPoint);

    if (c_roadSegment.laneWidth != 0) {
      laneWidth = LaneWidth(c_roadSegment.laneWidth.value);
    }

    if (c_roadSegment.speedLimits.address != 0) {
      speedLimits = SpeedLimitList.fromC(c_roadSegment.speedLimits.ref);
    }

    roadLaneSet = RoadLaneSetList.fromC(c_roadSegment.roadLaneSet);
  }
}
