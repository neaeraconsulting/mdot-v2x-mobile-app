import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/RestrictionUserType.dart';

class RestrictionUserTypeList{

 late List<RestrictionUserType> restrictionUserTypeList;

  RestrictionUserTypeList.fromC(C.RestrictionUserTypeList c_restrictionUserTypeList){
    restrictionUserTypeList = [];
    for(int i=0; i< c_restrictionUserTypeList.list.count; i++){
      restrictionUserTypeList.add(RestrictionUserType.fromC(c_restrictionUserTypeList.list.array[i].ref));
    }
  }
}