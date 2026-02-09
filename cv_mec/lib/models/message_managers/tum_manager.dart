
import 'dart:async';

import 'package:asn1_plugin/j2735/2024/common/temporary_id.dart';
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_ack_message/toll_usage_ack_message.dart';

class TumManager {

  Map<int, Timer> sendingTumTimers = <int, Timer>{};

  void addTimer(TemporaryID tempId, Timer timer) {
    int tempIdInt = tempId.toInt();
    sendingTumTimers[tempIdInt] = timer;
  }

  void cancelTimer(TemporaryID tempId) {
    int tempIdInt = tempId.toInt();
    Timer? timer = sendingTumTimers[tempIdInt];
    if (timer != null) {
      timer.cancel();
      sendingTumTimers.remove(tempIdInt);
    }
  }
}