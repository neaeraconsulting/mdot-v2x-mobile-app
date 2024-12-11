import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointLL.dart';
import 'package:cv_mec/models/J2735/OffsetLL_B12.dart';

class Node_LL_32B extends Choice_NodeOffsetPointLL {
  late OffsetLL_B12 lon;
  late OffsetLL_B12 lat;

  Node_LL_32B.fromC(C.Node_LL_32B nodeLL32b){
    lon = OffsetLL_B12(nodeLL32b.lon);
    lat = OffsetLL_B12(nodeLL32b.lat);
  }

  @override
  List<double> getOffsetLongLat(){
    return [lon.offsetLL_B12 / 1E7, lat.offsetLL_B12 / 1E7];
  }
}