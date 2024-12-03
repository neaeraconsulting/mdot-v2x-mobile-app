import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/SegmentAttributeLL.dart';
import 'dart:ffi';


class SegmentAttributeLLList{
  late List<SegmentAttributeLL> segmentAttributeLLList;

  SegmentAttributeLLList.fromC(C.SegmentAttributeLLList segmentAttributeList){

    for(int i =0; i< segmentAttributeList.list.count; i++){
      segmentAttributeLLList.add(SegmentAttributeLL.values[segmentAttributeList.list.array[i].value]);
    }

  }

}