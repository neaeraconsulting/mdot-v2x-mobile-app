import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointXY.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Node_LLmD_64b.dart';
import 'package:cv_mec/models/J2735/Node_XY_20b.dart';
import 'package:cv_mec/models/J2735/Node_XY_22b.dart';
import 'package:cv_mec/models/J2735/Node_XY_24b.dart';
import 'package:cv_mec/models/J2735/Node_XY_26b.dart';
import 'package:cv_mec/models/J2735/Node_XY_28b.dart';
import 'package:cv_mec/models/J2735/Node_XY_32b.dart';


class NodeOffsetPointXY {
  late Choice_NodeOffsetPointXY nodeOffsetPointXY;


  NodeOffsetPointXY.fromC(C.NodeOffsetPointXY nodeOffset){
    if(nodeOffset.present == 1){
      nodeOffsetPointXY = Node_XY_20b.fromC(nodeOffset.choice.node_XY1);
    }else if(nodeOffset.present == 2){
      nodeOffsetPointXY = Node_XY_22b.fromC(nodeOffset.choice.node_XY2);
    }else if(nodeOffset.present == 3){
      nodeOffsetPointXY = Node_XY_24b.fromC(nodeOffset.choice.node_XY3);
    }else if(nodeOffset.present == 4){
      nodeOffsetPointXY = Node_XY_26b.fromC(nodeOffset.choice.node_XY4);
    }else if(nodeOffset.present == 5){
      nodeOffsetPointXY = Node_XY_28b.fromC(nodeOffset.choice.node_XY5);
    }else if(nodeOffset.present == 6){
      nodeOffsetPointXY = Node_XY_32b.fromC(nodeOffset.choice.node_XY6);
    }else if(nodeOffset.present == 7){
      nodeOffsetPointXY = Node_LLmD_64b.fromC(nodeOffset.choice.node_LatLon);
    }else if(nodeOffset.present == 8){
      // nodeOffsetPointXY = RegionalExtension.fromC(nodeOffset.choice.regional);
    }else{
      print("Choice NodeOffsetPointXY ${nodeOffset.present} is invalid for NodeOffsetPointXY");
    }
  }

  
}