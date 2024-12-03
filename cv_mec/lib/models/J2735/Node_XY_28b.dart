import 'package:cv_mec/models/J2735/Offset_B14.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointXY.dart';

class Node_XY_28b extends Choice_NodeOffsetPointXY{
  late Offset_B14 x;
  late Offset_B14 y;

  Node_XY_28b.fromC(C.Node_XY_28b nodeXY28b){
    x = Offset_B14(nodeXY28b.x);
    y = Offset_B14(nodeXY28b.y);
  }
}