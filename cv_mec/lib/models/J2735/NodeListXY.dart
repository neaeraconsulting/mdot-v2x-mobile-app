import 'package:cv_mec/models/J2735/Choice_NodeListXY.dart';
import 'package:cv_mec/models/J2735/Choice_Offset.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/ComputedLane.dart';
import 'package:cv_mec/models/J2735/NodeSetXY.dart';

class NodeListXY extends Choice_Offset{
  late Choice_NodeListXY nodeListXY;


  NodeListXY.fromC(C.NodeListXY c_nodeListXY){
    if(c_nodeListXY.present == 1){
      nodeListXY = NodeSetXY.fromC(c_nodeListXY.choice.nodes);
    }else if(c_nodeListXY.present == 2){
      nodeListXY = ComputedLane.fromC(c_nodeListXY.choice.computed);
    }else{
      print("Choice nodeListXY ${c_nodeListXY.present} is invalid for NodeListXY");
    }
  }
}