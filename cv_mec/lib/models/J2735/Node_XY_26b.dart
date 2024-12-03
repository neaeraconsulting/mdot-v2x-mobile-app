import 'package:cv_mec/models/J2735/Offset_B13.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointXY.dart';

class Node_XY_26b extends Choice_NodeOffsetPointXY{
  late Offset_B13 x;
  late Offset_B13 y;

  Node_XY_26b.fromC(C.Node_XY_26b nodeXY26b){
    x = Offset_B13(nodeXY26b.x);
    y = Offset_B13(nodeXY26b.y);
  }
}