import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/node_attribute_ll.dart';

class NodeAttributeLLList {
  late List<NodeAttributeLL> nodeAttributeLLList;

  NodeAttributeLLList.fromC(C.NodeAttributeLLList nodeAttributeLL) {
    nodeAttributeLLList = [];
    for (int i = 0; i < nodeAttributeLL.list.count; i++) {
      nodeAttributeLLList
          .add(NodeAttributeLL.values[nodeAttributeLL.list.array[i].value]);
    }
  }
}
