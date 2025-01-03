import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_lane_data_attribute.dart';
import 'package:cv_mec/models/j2735/delta_angle.dart';
import 'package:cv_mec/models/j2735/merge_diverge_node_angle.dart';
import 'package:cv_mec/models/j2735/roadway_crown_angle.dart';

import 'package:cv_mec/models/j2735/speed_limit_list.dart';

class LaneDataAttribute {
  late Choice_LaneDataAttribute choice;

  LaneDataAttribute.fromC(C.LaneDataAttribute laneDataAttribute) {
    if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_pathEndPointAngle) {
      choice = DeltaAngle(laneDataAttribute.choice.pathEndPointAngle);
    } else if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_laneCrownPointCenter) {
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointCenter);
    } else if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_laneCrownPointLeft) {
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointLeft);
    } else if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_laneCrownPointRight) {
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointRight);
    } else if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_laneAngle) {
      choice = MergeDivergeNodeAngle(laneDataAttribute.choice.laneAngle);
    } else if (laneDataAttribute.present ==
        C.LaneDataAttribute_PR.LaneDataAttribute_PR_speedLimits) {
      choice = SpeedLimitList.fromC(laneDataAttribute.choice.speedLimits);
    } else {
      print(
          "Choice LaneDataAttribute ${laneDataAttribute.present} is invalid for LaneDataAttribute");
    }
  }
}
