import 'package:cv_mec/models/j2735/choice_node_offset_point_ll.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_node_offset_point_xy.dart';
import 'package:cv_mec/models/j2735/latitude.dart';
import 'package:cv_mec/models/j2735/longitude.dart';

class Node_LLmD_64b
    implements Choice_NodeOffsetPointXY, Choice_NodeOffsetPointLL {
  late Longitude lon;
  late Latitude lat;

  Node_LLmD_64b.fromC(C.Node_LLmD_64b nodeXY64b) {
    lon = Longitude(nodeXY64b.lon);
    lat = Latitude(nodeXY64b.lat);
  }

  @override
  List<double> getOffsetMeters() {
    return [0, 0];
  }

  @override
  List<double> getOffsetLongLat() {
    return [0, 0];
  }
}
