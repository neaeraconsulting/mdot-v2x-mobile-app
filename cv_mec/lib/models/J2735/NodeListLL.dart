import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_Offset.dart';
import 'package:cv_mec/models/J2735/NodeSetLL.dart';

class NodeListLL extends Choice_Offset{

  late NodeSetLL nodes;

  NodeListLL.fromC(C.NodeListLL nodeListLL){

    if(nodeListLL.present == 1){
      nodes = NodeSetLL.fromC(nodeListLL.choice.nodes);
    }else{
      print("Choice nodes ${nodeListLL.present} is invalid for NodeListLL");
    }
    

  }

}