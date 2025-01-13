import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/descriptive_name.dart';
import 'package:cv_mec/models/j2735/lane_width.dart';
import 'package:cv_mec/models/j2735/msg_count.dart';
import 'package:cv_mec/models/j2735/position_3d.dart';
import 'package:cv_mec/models/j2735/road_lane_set_list.dart';
import 'package:cv_mec/models/j2735/road_segment_reference_id.dart';
import 'package:cv_mec/models/j2735/speed_limit_list.dart';

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
