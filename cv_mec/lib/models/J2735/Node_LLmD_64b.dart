import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointLL.dart';
import 'package:cv_mec/models/J2735/Latitude.dart';
import 'package:cv_mec/models/J2735/Longitude.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointXY.dart';


class Node_LLmD_64b implements Choice_NodeOffsetPointXY, Choice_NodeOffsetPointLL{
  late Longitude lon;
  late Latitude lat;

  Node_LLmD_64b.fromC(C.Node_LLmD_64b nodeXY64b){
    lon = Longitude(nodeXY64b.lon);
    lat = Latitude(nodeXY64b.lat);
  }
}