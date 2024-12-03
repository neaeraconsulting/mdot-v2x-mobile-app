import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/LaneDataAttributeList.dart';
import 'package:cv_mec/models/J2735/NodeAttributeXYList.dart';
import 'package:cv_mec/models/J2735/Offset_B10.dart';
import 'package:cv_mec/models/J2735/RegionalExtension.dart';
import 'package:cv_mec/models/J2735/SegmentAttributeXYList.dart';

class NodeAttributeSetXY{
  late NodeAttributeXYList? localNode;
  late SegmentAttributeXYList? disabled;
  late SegmentAttributeXYList? enabled;
  late LaneDataAttributeList? data;
  late Offset_B10? dWidth;
  late Offset_B10? dElevation;
  late List<RegionalExtension>? regional;

  NodeAttributeSetXY.fromC(C.NodeAttributeSetXY nodeAttributeSetXY){

    if(nodeAttributeSetXY.localNode.address != 0){
      localNode = NodeAttributeXYList.fromC(nodeAttributeSetXY.localNode.ref);
    }

    if(nodeAttributeSetXY.disabled.address != 0){
      disabled = SegmentAttributeXYList.fromC(nodeAttributeSetXY.disabled.ref);
    }

    if(nodeAttributeSetXY.enabled.address != 0){
      enabled = SegmentAttributeXYList.fromC(nodeAttributeSetXY.enabled.ref);
    }

    if(nodeAttributeSetXY.data != 0){
      data = LaneDataAttributeList.fromC(nodeAttributeSetXY.data.ref);
    }

    if(nodeAttributeSetXY.dWidth.address !=0){
      dWidth = Offset_B10(nodeAttributeSetXY.dWidth.value);
    }

    if(nodeAttributeSetXY.dElevation.address !=0){
      dWidth = Offset_B10(nodeAttributeSetXY.dElevation.value);
    }
  }
}