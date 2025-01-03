import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/node_attribute_set_ll.dart';
import 'package:cv_mec/models/j2735/node_offset_point_ll.dart';
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
