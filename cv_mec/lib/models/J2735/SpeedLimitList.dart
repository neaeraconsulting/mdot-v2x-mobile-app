import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_LaneDataAttribute.dart';
import 'dart:ffi';

import 'package:cv_mec/models/J2735/RegulatorySpeedLimit.dart';

class SpeedLimitList extends Choice_LaneDataAttribute{
  late List<RegulatorySpeedLimit> speedLimitList;

  SpeedLimitList.fromC(C.SpeedLimitList speedList){
    speedLimitList = [];
    for(int i = 0; i< speedList.list.count; i++){
      speedLimitList.add(RegulatorySpeedLimit.fromC(speedList.list.array[i].ref));
    }
  }
}