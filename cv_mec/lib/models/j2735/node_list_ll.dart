import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_offset.dart';
import 'package:cv_mec/models/j2735/node_set_ll.dart';

class NodeListLL extends Choice_Offset {
  late NodeSetLL nodes;

  NodeListLL.fromC(C.NodeListLL nodeListLL) {
    if (nodeListLL.present == C.NodeListLL_PR.NodeListLL_PR_nodes) {
      nodes = NodeSetLL.fromC(nodeListLL.choice.nodes);
    } else {
      print("Choice nodes ${nodeListLL.present} is invalid for NodeListLL");
    }
  }
}
