
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_ack_message/toll_usage_ack_message.dart';

class TumAckManager {

  Map<int, TollUsageAckMessage> storedTams = <int, TollUsageAckMessage>{};

  TollUsageAckMessage getSampleTumAck() {
    String sampleTumAck = "002708003f7757550a4c90";
    ASNService asnService = Get.find<ASNService>();
    return asnService.decodeTumAck(sampleTumAck);
  }

  void add(TollUsageAckMessage tumAck) {
    storedTams[tumAck.tumAck.tumAck.first.tempId.temporaryID.first] = tumAck; //TODO: Fix this
  }

}