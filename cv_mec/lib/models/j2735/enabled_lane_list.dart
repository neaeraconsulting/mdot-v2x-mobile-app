import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/j2735/lane_id.dart';

class EnabledLaneList {
  late List<LaneID> enabledLaneList;

  EnabledLaneList.fromC(C.EnabledLaneList c_enabledLaneList) {
    enabledLaneList = [];
    for (int i = 0; i < c_enabledLaneList.list.count; i++) {
      enabledLaneList.add(LaneID(c_enabledLaneList.list.array[i].value));
    }
  }
}
