import 'dart:ffi';

import 'package:cv_mec/models/J2735/J2735.dart';
import 'package:cv_mec/models/J2735/MinuteOfTheYear.dart';
import 'package:cv_mec/models/J2735/MsgCount.dart';
import 'package:cv_mec/models/J2735/TravelerDataFrameList.dart';
import 'package:cv_mec/models/J2735/URL_Base.dart';
import 'package:cv_mec/models/J2735/UniqueMSGID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;


class TravelerInformation{
  late MsgCount msgCnt;
  late MinuteOfTheYear? timestamp;
  late UniqueMSGID? packetID;
  late URL_Base? urlB;

  late TravelerDataFrameList dataFrames;

  late List<RegionalExtension> regional;

  TravelerInformation.fromC(C.TravelerInformation c_tim){
    
    this.msgCnt = MsgCount(c_tim.msgCnt);

    if(c_tim.timeStamp.address != 0){
      this.timestamp = MinuteOfTheYear(c_tim.timeStamp.value);
    }else{
      this.timestamp = null;
    }
    
    if(c_tim.packetID.address != 0){
      this.packetID = UniqueMSGID.fromOctetString(c_tim.packetID.ref);
    }else{
      this.packetID = null;
    }
    

    if(c_tim.urlB.address != 0){
      this.urlB = URL_Base.fromOctetString(c_tim.urlB.ref);
    }else{
      this.urlB = null;
    }
    

    this.dataFrames = TravelerDataFrameList.fromC(c_tim.dataFrames);

    // this.regional = RegionalExtension.fromC(c_tim.regional);


  }
}