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
    
    // Clean up existing allocations first
    _cleanupExistingAllocations(c_obeId);
    
    // Zero-initialize the struct
    pointer.cast<Uint8>().asTypedList(sizeOf<C.ObeId>()).fillRange(0, sizeOf<C.ObeId>(), 0);
    
    // Handle manufacturerId (direct int value)
    c_obeId.manufacturerId = manufacturerId ?? 0;
    
    // Handle equipmentObuId (OCTET_STRING)
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
  
  void _cleanupExistingAllocations(C.ObeId c_obeId) {
    // Clean up equipmentObuId buffer
    if (c_obeId.equipmentObuId.buf != nullptr) {
      calloc.free(c_obeId.equipmentObuId.buf);
      c_obeId.equipmentObuId.buf = nullptr;
      c_obeId.equipmentObuId.size = 0;
    }
  }
}