import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;

class ObeId {
  int? manufacturerId;
  String? equipmentObuId;
  
  ObeId.fromC(C.ObeId c_obj){
    manufacturerId = c_obj.manufacturerId;
    if(c_obj.equipmentObuId.buf != nullptr && c_obj.equipmentObuId.size > 0){
        final byteList = c_obj.equipmentObuId.buf.asTypedList(c_obj.equipmentObuId.size);
        equipmentObuId = String.fromCharCodes(byteList);
    }
  }
}