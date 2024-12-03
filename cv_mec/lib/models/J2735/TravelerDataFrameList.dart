import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/TravelerDataFrame.dart';

class TravelerDataFrameList {
  late List<TravelerDataFrame> travelerDataFrameList;

  TravelerDataFrameList(List<TravelerDataFrame> list){
    this.travelerDataFrameList = list;
  }

  TravelerDataFrameList.empty() {
    this.travelerDataFrameList = [];
  }

  TravelerDataFrameList.fromC(C.TravelerDataFrameList c_dataFrames){
    List<TravelerDataFrame> list = [];
    for(int i =0; i< c_dataFrames.list.count; i++){
      list.add(TravelerDataFrame.fromC(c_dataFrames.list.array[i].ref));
    }
  }
}