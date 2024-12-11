import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/RestrictionAppliesTo.dart';

class RestrictionUserType {
  RestrictionAppliesTo? basicType;

  RestrictionUserType.fromC(C.RestrictionUserType c_restrictionUserType) {
    if (c_restrictionUserType.present == 0) {
      basicType =
          RestrictionAppliesTo.values[c_restrictionUserType.choice.basicType];
    }
  }
}
