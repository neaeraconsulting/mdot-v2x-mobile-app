import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/J2735.dart';

class OverlayLaneList {
  late List<LaneID> overlayLaneList;


  OverlayLaneList.fromC(C.OverlayLaneList c_overlayLaneList){
    overlayLaneList = [];
    for(int i =0; i< c_overlayLaneList.list.count; i++){
      overlayLaneList.add(LaneID(c_overlayLaneList.list.array[i].value));
    }
  }
  
}