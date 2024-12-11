import 'package:cv_mec/models/J2735/RestrictionClassID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/RestrictionUserTypeList.dart';

class RestrictionClassAssignment{

  late RestrictionClassID id;
  late RestrictionUserTypeList users;

  RestrictionClassAssignment.fromC(C.RestrictionClassAssignment c_restrictionClassAssignment){

    id = RestrictionClassID(c_restrictionClassAssignment.id);
    users = RestrictionUserTypeList.fromC(c_restrictionClassAssignment.users);

  }
}