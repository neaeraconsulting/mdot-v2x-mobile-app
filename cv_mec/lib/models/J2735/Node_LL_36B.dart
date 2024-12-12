import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_NodeOffsetPointLL.dart';
import 'package:cv_mec/models/J2735/OffsetLL_B12.dart';

class Node_LL_36B extends Choice_NodeOffsetPointLL {
  late OffsetLL_B12 lon;
  late OffsetLL_B12 lat;

  Node_LL_36B.fromC(C.Node_LL_36B nodeLL36b){
    lon = OffsetLL_B12(nodeLL36b.lon);
    lat = OffsetLL_B12(nodeLL36b.lat);
  }

  List<double> getOffsetLongLat(){
    return [lon.offsetLL_B12 / 1E7, lat.offsetLL_B12 / 1E7];
  }
}