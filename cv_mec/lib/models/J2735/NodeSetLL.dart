import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/NodeLL.dart';

class NodeSetLL{
  late List<NodeLL> nodeSetLL;

  NodeSetLL.fromC(C.NodeSetLL nodeSet){
    nodeSetLL = [];
    for(int i=0; i< nodeSet.list.count; i++){
      nodeSetLL.add(NodeLL.fromC(nodeSet.list.array[i].ref));
    }
  }
}