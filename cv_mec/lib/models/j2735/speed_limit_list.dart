import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/choice_lane_data_attribute.dart';
import 'dart:ffi';

import 'package:cv_mec/models/j2735/regulatory_speed_limit.dart';

class SpeedLimitList extends Choice_LaneDataAttribute {
  late List<RegulatorySpeedLimit> speedLimitList;

  SpeedLimitList.fromC(C.SpeedLimitList speedList) {
    speedLimitList = [];
    for (int i = 0; i < speedList.list.count; i++) {
      speedLimitList
          .add(RegulatorySpeedLimit.fromC(speedList.list.array[i].ref));
    }
  }
}
