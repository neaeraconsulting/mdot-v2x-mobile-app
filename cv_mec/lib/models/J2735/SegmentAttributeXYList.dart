import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/J2735/SegmentAttributeXY.dart';

class SegmentAttributeXYList {
  late List<SegmentAttributeXY> segmentAttributeXYList;

  SegmentAttributeXYList.fromC(C.SegmentAttributeXYList segmentList){
    segmentAttributeXYList = [];
    for(int i=0; i< segmentList.list.count; i++){
      segmentAttributeXYList.add(SegmentAttributeXY.values[segmentList.list.array[i].value]);
    }
  }
}