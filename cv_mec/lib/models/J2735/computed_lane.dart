import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/angle.dart';
import 'package:cv_mec/models/j2735/choice_node_list_xy.dart';
import 'package:cv_mec/models/j2735/choice_offset_axis.dart';
import 'package:cv_mec/models/j2735/driven_line_offset_lg.dart';
import 'package:cv_mec/models/j2735/driven_line_offset_sm.dart';
import 'package:cv_mec/models/j2735/lane_id.dart';
import 'package:cv_mec/models/j2735/regional_extension.dart';
import 'package:cv_mec/models/j2735/Scale_B12.dart';

class ComputedLane extends Choice_NodeListXY {
  late LaneID referenceLaneId;
  late Choice_OffsetAxis offsetXaxis;
  late Choice_OffsetAxis offsetYaxis;

  Angle? rotateXY;
  Scale_B12? scaleXaxis;
  Scale_B12? scaleYaxis;

  List<RegionalExtension>? regional;

  ComputedLane.fromC(C.ComputedLane computedLane) {
    referenceLaneId = LaneID(computedLane.referenceLaneId);

    if (computedLane.offsetXaxis.present ==
        C.ComputedLane__offsetXaxis_PR.ComputedLane__offsetXaxis_PR_small) {
      offsetXaxis = DrivenLineOffsetSm(computedLane.offsetXaxis.choice.small);
    } else if (computedLane.offsetXaxis.present ==
        C.ComputedLane__offsetXaxis_PR.ComputedLane__offsetXaxis_PR_large) {
      offsetXaxis = DrivenLineOffsetLg(computedLane.offsetXaxis.choice.large);
    } else {
      print(
          "Choice offsetXaxis ${computedLane.offsetXaxis.present} is invalid for ComputedLane");
    }

    if (computedLane.offsetYaxis.present == 1) {
      offsetYaxis = DrivenLineOffsetSm(computedLane.offsetYaxis.choice.small);
    } else if (computedLane.offsetYaxis.present == 2) {
      offsetYaxis = DrivenLineOffsetLg(computedLane.offsetYaxis.choice.large);
    } else {
      print(
          "Choice offsetYaxis ${computedLane.offsetYaxis.present} is invalid for ComputedLane");
    }

    if (computedLane.rotateXY.address != 0) {
      rotateXY = Angle(computedLane.rotateXY.value);
    }

    if (computedLane.scaleXaxis.address != 0) {
      scaleXaxis = Scale_B12(computedLane.scaleXaxis.value);
    }

    if (computedLane.scaleYaxis.address != 0) {
      scaleYaxis = Scale_B12(computedLane.scaleYaxis.value);
    }
  }
}
