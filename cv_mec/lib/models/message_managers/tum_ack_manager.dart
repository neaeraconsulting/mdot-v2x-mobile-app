
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_ack_message/toll_usage_ack_message.dart';

class TumAckManager {

  Map<int, TollUsageAckMessage> storedTams = <int, TollUsageAckMessage>{};

  TollUsageAckMessage getSampleTumAck() {
    ASNService asnService = Get.find<ASNService>();
    return asnService.decodeTumAck(TestData.testTumAck);
  }

  bool isNewTumAck(TollUsageAckMessage tumAck) {
    return !storedTams.containsKey(tumAck.tumAck.tumAck.first.tempId.temporaryID.first);
  }

  void add(TollUsageAckMessage tumAck) {
    storedTams[tumAck.tumAck.tumAck.first.tempId.temporaryID.first] = tumAck;
  }

}