import 'package:cv_mec/models/j2735/bsm_core_data.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class BasicSafetyMessage {
  late BSMcoreData coreData;

  BasicSafetyMessage.fromC(C.BasicSafetyMessage basicSafetyMessage) {
    coreData = BSMcoreData.fromC(basicSafetyMessage.coreData);
  }
}
