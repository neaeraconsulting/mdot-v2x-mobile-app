import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/J2735.dart';
import 'dart:ffi';

class NodeAttributeSetLL {
  NodeAttributeLLList? localNode;
  SegmentAttributeLLList? disabled;
  SegmentAttributeLLList? enabled;
  LaneDataAttributeList? data;
  Offset_B10? dWidth;
  Offset_B10? dElevation;
  RegionalExtension? regional;

  NodeAttributeSetLL.fromC(C.NodeAttributeSetLL nodeAttributeSetLL) {
    if (nodeAttributeSetLL.localNode.address != 0) {
      localNode = NodeAttributeLLList.fromC(nodeAttributeSetLL.localNode.ref);
    }

    if (nodeAttributeSetLL.disabled.address != 0) {
      disabled = SegmentAttributeLLList.fromC(nodeAttributeSetLL.disabled.ref);
    }

    if (nodeAttributeSetLL.enabled.address != 0) {
      enabled = SegmentAttributeLLList.fromC(nodeAttributeSetLL.enabled.ref);
    }

    if (nodeAttributeSetLL.data.address != 0) {
      data = LaneDataAttributeList.fromC(nodeAttributeSetLL.data.ref);
    }

    if (nodeAttributeSetLL.dWidth.address != 0) {
      dWidth = Offset_B10(nodeAttributeSetLL.dWidth.value);
    }

    if (nodeAttributeSetLL.dElevation.address != 0) {
      dElevation = Offset_B10(nodeAttributeSetLL.dElevation.value);
    }

    if (nodeAttributeSetLL.regional.address != 0) {
      // regional = RegionalExtension.fromC(nodeAttributeSetLL.regional.ref);
    }
  }
}
