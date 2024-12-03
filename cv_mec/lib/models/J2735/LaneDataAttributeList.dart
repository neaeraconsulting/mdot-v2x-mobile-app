import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/LaneDataAttribute.dart';

class LaneDataAttributeList {

  late List<LaneDataAttribute> laneDataAttributeList;

  LaneDataAttributeList.fromC(C.LaneDataAttributeList laneDataList){
    laneDataAttributeList = [];
    for(int i=0; i< laneDataList.list.count; i++){
      laneDataAttributeList.add(LaneDataAttribute.fromC(laneDataList.list.array[i].ref));
    }
  }
}