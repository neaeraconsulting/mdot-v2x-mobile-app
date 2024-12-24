import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_msg_id.dart';
import 'package:cv_mec/models/j2735/choice_content.dart';
import 'package:cv_mec/models/j2735/d_year.dart';
import 'package:cv_mec/models/j2735/exit_service.dart';
import 'package:cv_mec/models/j2735/further_info_id.dart';
import 'package:cv_mec/models/j2735/generic_signage.dart';
import 'package:cv_mec/models/j2735/geographical_path.dart';
import 'package:cv_mec/models/j2735/itis_itis_codes_and_text.dart';
import 'package:cv_mec/models/j2735/minute_of_the_year.dart';
import 'package:cv_mec/models/j2735/minutes_duration.dart';
import 'package:cv_mec/models/j2735/road_sign_id.dart';
import 'package:cv_mec/models/j2735/sign_priority.dart';
import 'package:cv_mec/models/j2735/speed_limit.dart';
import 'package:cv_mec/models/j2735/traveler_info_type.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/url_short.dart';
import 'package:cv_mec/models/j2735/work_zone.dart';

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
