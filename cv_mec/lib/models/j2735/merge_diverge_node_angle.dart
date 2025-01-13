import 'package:cv_mec/models/j2735/choice_lane_data_attribute.dart';

class MergeDivergeNodeAngle extends Choice_LaneDataAttribute {
  late int mergeDivergeNodeAngle;

  MergeDivergeNodeAngle(this.mergeDivergeNodeAngle);

  MergeDivergeNodeAngle.Unknown() {
    mergeDivergeNodeAngle = 0;
  }
}
