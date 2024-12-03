import 'package:cv_mec/models/J2735/Choice_LaneDataAttribute.dart';

class MergeDivergeNodeAngle extends Choice_LaneDataAttribute{
  late int mergeDivergeNodeAngle;

  MergeDivergeNodeAngle(this.mergeDivergeNodeAngle);

  MergeDivergeNodeAngle.Unknown(){
    mergeDivergeNodeAngle = 0;
  }
}