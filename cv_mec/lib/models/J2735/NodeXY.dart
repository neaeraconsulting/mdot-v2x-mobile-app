import 'dart:ffi';

import 'package:cv_mec/models/J2735/NodeAttributeSetXY.dart';
import 'package:cv_mec/models/J2735/NodeOffsetPointXY.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class NodeXY {
  late NodeOffsetPointXY delta;
  NodeAttributeSetXY? attributes;

  NodeXY.fromC(C.NodeXY nodeXY) {
    delta = NodeOffsetPointXY.fromC(nodeXY.delta);

    if (nodeXY.attributes.address != 0) {
      attributes = NodeAttributeSetXY.fromC(nodeXY.attributes.ref);
    }
  }
}
