import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/RoadSegment.dart';

class RoadSegmentList {
  late List<RoadSegment> roadSegmentList;

  RoadSegmentList.fromC(C.RoadSegmentList c_roadSegmentList){
    roadSegmentList = [];
    for(int i=0; i< c_roadSegmentList.list.count; i++){
      roadSegmentList.add(RoadSegment.fromC(c_roadSegmentList.list.array[i].ref));
    }
  }
}