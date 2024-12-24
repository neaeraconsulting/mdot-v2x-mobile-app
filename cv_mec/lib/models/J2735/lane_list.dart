import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/generic_lane.dart';

class LaneList {
  late List<GenericLane> laneList;

  LaneList.fromC(C.LaneList c_laneList) {
    laneList = [];
    for (int i = 0; i < c_laneList.list.count; i++) {
      laneList.add(GenericLane.fromC(c_laneList.list.array[i].ref));
    }
  }
}
