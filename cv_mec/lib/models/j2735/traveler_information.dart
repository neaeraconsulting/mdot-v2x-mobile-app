import 'dart:ffi';

import 'package:cv_mec/models/j2735/J2735.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class TravelerInformation {
  late MsgCount msgCnt;
  MinuteOfTheYear? timestamp;
  UniqueMSGID? packetID;
  URL_Base? urlB;

  late TravelerDataFrameList dataFrames;

  late List<RegionalExtension> regional;

  TravelerInformation.fromC(C.TravelerInformation c_tim) {
    msgCnt = MsgCount(c_tim.msgCnt);

    if (c_tim.timeStamp.address != 0) {
      timestamp = MinuteOfTheYear(c_tim.timeStamp.value);
    } else {
      timestamp = null;
    }

    if (c_tim.packetID.address != 0) {
      packetID = UniqueMSGID.fromOctetString(c_tim.packetID.ref);
    } else {
      packetID = null;
    }

    if (c_tim.urlB.address != 0) {
      urlB = URL_Base.fromOctetString(c_tim.urlB.ref);
    } else {
      urlB = null;
    }

    dataFrames = TravelerDataFrameList.fromC(c_tim.dataFrames);

    // this.regional = RegionalExtension.fromC(c_tim.regional);
  }
}
