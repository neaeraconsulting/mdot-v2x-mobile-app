import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/NodeAttributeSetLL.dart';
import 'package:cv_mec/models/J2735/NodeOffsetPointLL.dart';
import 'dart:ffi';

class NodeLL {
  late NodeOffsetPointLL delta;
  NodeAttributeSetLL? attributes;

  NodeLL.fromC(C.NodeLL nodeLL) {
    delta = NodeOffsetPointLL.fromC(nodeLL.delta);

    if (nodeLL.attributes.address != 0) {
      attributes = NodeAttributeSetLL.fromC(nodeLL.attributes.ref);
    }
  }
}
