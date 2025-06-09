import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j2735/2024/basic_safety_message/bsm_core_data.dart';

class BasicSafetyMessage {
  late BSMcoreData coreData;

  BasicSafetyMessage.fromC(C.BasicSafetyMessage basicSafetyMessage) {
    coreData = BSMcoreData.fromC(basicSafetyMessage.coreData);
  }
}
