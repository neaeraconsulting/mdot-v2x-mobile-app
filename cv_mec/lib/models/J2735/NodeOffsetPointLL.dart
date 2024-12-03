
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointLL.dart';
import 'package:cv_mec/models/J2735/Node_LL_24B.dart';
import 'package:cv_mec/models/J2735/Node_LL_28B.dart';
import 'package:cv_mec/models/J2735/Node_LL_32B.dart';
import 'package:cv_mec/models/J2735/Node_LL_36B.dart';
import 'package:cv_mec/models/J2735/Node_LL_44B.dart';
import 'package:cv_mec/models/J2735/Node_LL_48B.dart';
import 'package:cv_mec/models/J2735/Node_LLmD_64b.dart';

class NodeOffsetPointLL{
  late Choice_NodeOffsetPointLL nodeOffsetPointLL;

  NodeOffsetPointLL.fromC(C.NodeOffsetPointLL nodeOffsetPoint){

    if(nodeOffsetPoint.present == 1){
      nodeOffsetPointLL = Node_LL_24B.fromC(nodeOffsetPoint.choice.node_LL1);
    } else if(nodeOffsetPoint.present == 2){
      nodeOffsetPointLL = Node_LL_28B.fromC(nodeOffsetPoint.choice.node_LL2);
    } else if(nodeOffsetPoint.present == 3){
      nodeOffsetPointLL = Node_LL_32B.fromC(nodeOffsetPoint.choice.node_LL3);
    } else if(nodeOffsetPoint.present == 4){
      nodeOffsetPointLL = Node_LL_36B.fromC(nodeOffsetPoint.choice.node_LL4);
    } else if(nodeOffsetPoint.present == 5){
      nodeOffsetPointLL = Node_LL_44B.fromC(nodeOffsetPoint.choice.node_LL5);
    } else if(nodeOffsetPoint.present == 6){
      nodeOffsetPointLL = Node_LL_48B.fromC(nodeOffsetPoint.choice.node_LL6);
    } else if(nodeOffsetPoint.present == 7){
      nodeOffsetPointLL = Node_LLmD_64b.fromC(nodeOffsetPoint.choice.node_LatLon);
    } else if(nodeOffsetPoint.present == 8){

    } else{
      print("Choice nodeOffsetPoint ${nodeOffsetPoint.present} is invalid for NodeOffsetPointLL");
    }

  }
}