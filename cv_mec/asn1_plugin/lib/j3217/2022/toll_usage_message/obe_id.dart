import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:ffi/ffi.dart';

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

  void toC(Pointer<C.ObeId> pointer) {
    final c_obeId = pointer.ref;
    
    pointer.cast<Uint8>().asTypedList(sizeOf<C.ObeId>()).fillRange(0, sizeOf<C.ObeId>(), 0);
    
    c_obeId.manufacturerId = manufacturerId ?? 0;
    
    if (equipmentObuId != null) {
      List<int> bytes = equipmentObuId!.codeUnits;
      if (bytes.isNotEmpty) {
        c_obeId.equipmentObuId.buf = calloc<Uint8>(bytes.length);
        c_obeId.equipmentObuId.size = bytes.length;
        
        for (int i = 0; i < bytes.length; i++) {
          c_obeId.equipmentObuId.buf[i] = bytes[i];
        }
      } else {
        c_obeId.equipmentObuId.buf = nullptr;
        c_obeId.equipmentObuId.size = 0;
      }
    } else {
      c_obeId.equipmentObuId.buf = nullptr;
      c_obeId.equipmentObuId.size = 0;
    }
  }
  
  void free(Pointer<C.ObeId> pointer) {
    final c_obeId = pointer.ref;
    
    if (c_obeId.equipmentObuId.buf != nullptr) {
      calloc.free(c_obeId.equipmentObuId.buf);
      c_obeId.equipmentObuId.buf = nullptr;
      c_obeId.equipmentObuId.size = 0;
    }
    
    calloc.free(pointer);
  }
}