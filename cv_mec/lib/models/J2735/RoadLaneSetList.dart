import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/GenericLane.dart';

class RoadLaneSetList{
  late List<GenericLane> roadLaneSetList;

  RoadLaneSetList.fromC(C.RoadLaneSetList c_roadLaneSetList){
    roadLaneSetList = [];
    for(int i =0; i< c_roadLaneSetList.list.count; i++){
      roadLaneSetList.add(GenericLane.fromC(c_roadLaneSetList.list.array[i].ref));
    }
  }
}