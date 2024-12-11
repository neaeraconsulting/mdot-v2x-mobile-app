import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_MsgID.dart';
import 'package:cv_mec/models/J2735/Choice_Content.dart';
import 'package:cv_mec/models/J2735/DYear.dart';
import 'package:cv_mec/models/J2735/ExitService.dart';
import 'package:cv_mec/models/J2735/FurtherInfoID.dart';
import 'package:cv_mec/models/J2735/GenericSignage.dart';
import 'package:cv_mec/models/J2735/GeographicalPath.dart';
import 'package:cv_mec/models/J2735/ITIS_ITIScodesAndText.dart';
import 'package:cv_mec/models/J2735/MinuteOfTheYear.dart';
import 'package:cv_mec/models/J2735/MinutesDuration.dart';
import 'package:cv_mec/models/J2735/RoadSignID.dart';
import 'package:cv_mec/models/J2735/SpeedLimit.dart';
import 'package:cv_mec/models/J2735/TravelerInfoType.dart';
import 'package:cv_mec/models/J2735/SignPriority.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/URL_Short.dart';
import 'package:cv_mec/models/J2735/WorkZone.dart';

class TravelerDataFrame {
  late TravelerInfoType frameType;
  late Choice_MsgID msgId;
  DYear? startYear;
  late MinuteOfTheYear startTime;
  late MinutesDuration durationTime;
  late SignPriority priority;
  late List<GeographicalPath> regions;
  late Choice_Content content;
  URL_Short? url;

  TravelerDataFrame.fromC(C.TravelerDataFrame c_dataFrame) {
    // Set Frame Type
    frameType = TravelerInfoType.values[c_dataFrame.frameType];

    // Set Message Choice
    int msgChoiceID = c_dataFrame.msgId.present;
    if (msgChoiceID == 1) {
      msgId =
          FurtherInfoId.fromOctetString(c_dataFrame.msgId.choice.furtherInfoID);
    } else if (msgChoiceID == 2) {
      msgId = RoadSignID.fromC(c_dataFrame.msgId.choice.roadSignID);
    } else {
      print("Tim has Invalid Choice ${c_dataFrame.msgId.present} for MsgID.");
    }

    // Set D Year
    if (c_dataFrame.startYear.address != 0) {
      startYear = DYear(c_dataFrame.startYear.value);
    }

    // Set Start Time
    startTime = MinuteOfTheYear(c_dataFrame.startTime);

    // Set Duration Time
    durationTime = MinutesDuration(c_dataFrame.durationTime);

    // Set Sign Priority
    priority = SignPriority(c_dataFrame.priority);

    // Set Geographical Paths
    regions = [];
    for (int i = 0; i < c_dataFrame.regions.list.count; i++) {
      regions
          .add(GeographicalPath.fromC(c_dataFrame.regions.list.array[i].ref));
    }

    // Set Content
    int contentChoiceID = c_dataFrame.content.present;
    if (contentChoiceID == 1) {
      content =
          ITIS_ITIScodesAndText.fromC(c_dataFrame.content.choice.advisory);
    } else if (contentChoiceID == 2) {
      content = WorkZone.fromC(c_dataFrame.content.choice.workZone);
    } else if (contentChoiceID == 3) {
      content = GenericSignage.fromC(c_dataFrame.content.choice.genericSign);
    } else if (contentChoiceID == 4) {
      content = SpeedLimit.fromC(c_dataFrame.content.choice.speedLimit);
    } else if (contentChoiceID == 5) {
      content = ExitService.fromC(c_dataFrame.content.choice.exitService);
    } else {}

    if (c_dataFrame.url.address != 0) {
      url = URL_Short.fromOctetString(c_dataFrame.url.ref);
    }
  }
}
