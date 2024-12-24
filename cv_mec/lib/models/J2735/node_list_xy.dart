import 'package:cv_mec/models/j2735/choice_node_list_xy.dart';
import 'package:cv_mec/models/j2735/choice_offset.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/computed_lane.dart';
import 'package:cv_mec/models/j2735/node_set_xy.dart';

class NodeListXY extends Choice_Offset {
  late Choice_NodeListXY nodeListXY;

  NodeListXY.fromC(C.NodeListXY c_nodeListXY) {
    if (c_nodeListXY.present == C.NodeListXY_PR.NodeListXY_PR_nodes) {
      nodeListXY = NodeSetXY.fromC(c_nodeListXY.choice.nodes);
    } else if (c_nodeListXY.present == C.NodeListXY_PR.NodeListXY_PR_computed) {
      nodeListXY = ComputedLane.fromC(c_nodeListXY.choice.computed);
    } else {
      print(
          "Choice nodeListXY ${c_nodeListXY.present} is invalid for NodeListXY");
    }
  }
}
