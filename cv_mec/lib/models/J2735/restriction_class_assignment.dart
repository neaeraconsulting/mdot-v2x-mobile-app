import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/restriction_class_id.dart';
import 'package:cv_mec/models/j2735/restriction_user_type_list.dart';

class RestrictionClassAssignment {
  late RestrictionClassID id;
  late RestrictionUserTypeList users;

  RestrictionClassAssignment.fromC(
      C.RestrictionClassAssignment c_restrictionClassAssignment) {
    id = RestrictionClassID(c_restrictionClassAssignment.id);
    users = RestrictionUserTypeList.fromC(c_restrictionClassAssignment.users);
  }
}
