import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/path_history_point.dart';

class PathHistoryPointList {
  late List<PathHistoryPoint> pathHistoryPointList;

  PathHistoryPointList.fromC(C.PathHistoryPointList c_pathHistoryPointList) {
    pathHistoryPointList = [];
    for (int i = 0; i < c_pathHistoryPointList.list.count; i++) {
      pathHistoryPointList.add(
          PathHistoryPoint.fromC(c_pathHistoryPointList.list.array[i].ref));
    }
  }
}
