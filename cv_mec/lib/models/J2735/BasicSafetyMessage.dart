

import 'package:cv_mec/models/J2735/BSMCoreData.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class BasicSafetyMessage{
  late BSMcoreData coreData;

  BasicSafetyMessage.fromC(C.BasicSafetyMessage basicSafetyMessage){
    coreData = BSMcoreData.fromC(basicSafetyMessage.coreData);
  }

  // void toC(C.BasicSafetyMessage basicSafetyMessage){
  //   basicSafetyMessage.coreData = coreData.toC(basicSafetyMessage.coreData);
  // }
}