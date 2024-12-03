import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Angle.dart';
import 'package:cv_mec/models/J2735/Choice_NodeListXY.dart';
import 'package:cv_mec/models/J2735/Choice_OffsetAxis.dart';
import 'package:cv_mec/models/J2735/DrivenLineOffsetLg.dart';
import 'package:cv_mec/models/J2735/DrivenLineOffsetSm.dart';
import 'package:cv_mec/models/J2735/LaneID.dart';
import 'package:cv_mec/models/J2735/RegionalExtension.dart';
import 'package:cv_mec/models/J2735/Scale_B12.dart';

class ComputedLane extends Choice_NodeListXY {
  late LaneID referenceLaneId;
  late Choice_OffsetAxis offsetXaxis;
  late Choice_OffsetAxis offsetYaxis;

  late Angle? rotateXY;
  late Scale_B12? scaleXaxis;
  late Scale_B12? scaleYaxis;

  List<RegionalExtension>? regional;


  ComputedLane.fromC(C.ComputedLane computedLane){
    referenceLaneId = LaneID(computedLane.referenceLaneId);

    if(computedLane.offsetXaxis.present == 1){
      offsetXaxis = DrivenLineOffsetSm(computedLane.offsetXaxis.choice.small);
    }else if(computedLane.offsetXaxis.present == 2){
      offsetXaxis = DrivenLineOffsetLg(computedLane.offsetXaxis.choice.large);
    }else{
      print("Choice offsetXaxis ${computedLane.offsetXaxis.present} is invalid for ComputedLane");
    }

    if(computedLane.offsetYaxis.present == 1){
      offsetYaxis = DrivenLineOffsetSm(computedLane.offsetYaxis.choice.small);
    }else if(computedLane.offsetYaxis.present == 2){
      offsetYaxis = DrivenLineOffsetLg(computedLane.offsetYaxis.choice.large);
    }else{
      print("Choice offsetYaxis ${computedLane.offsetYaxis.present} is invalid for ComputedLane");
    }

    if(computedLane.rotateXY.address != 0){
      rotateXY = Angle(computedLane.rotateXY.value);
    }

    if(computedLane.scaleXaxis.address != 0){
      scaleXaxis = Scale_B12(computedLane.scaleXaxis.value);
    }

    if(computedLane.scaleYaxis.address != 0){
      scaleYaxis = Scale_B12(computedLane.scaleYaxis.value);
    }
  }
}