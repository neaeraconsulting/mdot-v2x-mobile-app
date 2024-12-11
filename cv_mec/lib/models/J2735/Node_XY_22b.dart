import 'package:cv_mec/models/J2735/Offset_B11.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointXY.dart';


class Node_XY_22b extends Choice_NodeOffsetPointXY{
  late Offset_B11 x;
  late Offset_B11 y;

  Node_XY_22b.fromC(C.Node_XY_22b nodeXY22b){
    x = Offset_B11(nodeXY22b.x);
    y = Offset_B11(nodeXY22b.y);
  }

  @override
  List<double> getOffsetMeters(){
    return [x.offset_B11/100.0, y.offset_B11/100.0];
  }
}