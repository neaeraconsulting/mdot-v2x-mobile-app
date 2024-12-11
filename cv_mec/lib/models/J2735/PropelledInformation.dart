import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/AnimalPropelledType.dart';
import 'package:cv_mec/models/J2735/HumanPropelledType.dart';
import 'package:cv_mec/models/J2735/MotorziedPropelledType.dart';

class PropelledInformation {
  HumanPropelledType? human;
  AnimalPropelledType? animal;
  MotorizedPropelledType? motor;

  PropelledInformation.fromC(C.PropelledInformation c_propelledInformation) {
    if (c_propelledInformation.present == 0) {
      human = HumanPropelledType.values[c_propelledInformation.choice.human];
    } else if (c_propelledInformation.present == 1) {
      animal = AnimalPropelledType.values[c_propelledInformation.choice.animal];
    } else if (c_propelledInformation.present == 2) {
      motor =
          MotorizedPropelledType.values[c_propelledInformation.choice.motor];
    }
  }
}
