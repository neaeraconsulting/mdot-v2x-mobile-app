import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_node_offset_point_xy.dart';
import 'package:cv_mec/models/j2735/offset_b14.dart';

class Node_XY_28b extends Choice_NodeOffsetPointXY {
  late Offset_B14 x;
  late Offset_B14 y;

  Node_XY_28b.fromC(C.Node_XY_28b nodeXY28b) {
    x = Offset_B14(nodeXY28b.x);
    y = Offset_B14(nodeXY28b.y);
  }

  @override
  List<double> getOffsetMeters() {
    return [x.offset_B14 / 100.0, y.offset_B14 / 100.0];
  }
}
