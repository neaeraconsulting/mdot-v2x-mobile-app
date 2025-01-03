import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_node_list_xy.dart';
import 'package:cv_mec/models/j2735/node_xy.dart';

class NodeSetXY extends Choice_NodeListXY {
  late List<NodeXY> nodeSetXY;

  NodeSetXY.fromC(C.NodeSetXY nodeSet) {
    nodeSetXY = [];
    for (int i = 0; i < nodeSet.list.count; i++) {
      nodeSetXY.add(NodeXY.fromC(nodeSet.list.array[i].ref));
    }
  }
}
