import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart';
import 'package:ffi/ffi.dart';

class TemporaryID{
  late List<int> temporaryID;

  TemporaryID.fromOctetString(OCTET_STRING string){
    temporaryID = string.buf.asTypedList(string.size);
  }

  TemporaryID(List<int> id){
    temporaryID = id;
  }


  void toOctetString(OCTET_STRING string){
    for (int i = 0; i < temporaryID.length; i++) {
      string.buf[i] = temporaryID[i];
    }
  }

  void toC(Pointer<OCTET_STRING> pointer) {
    final c_tempID = pointer.ref;

    if (c_tempID.buf != nullptr && c_tempID.size > 0) {
      calloc.free(c_tempID.buf);
      c_tempID.buf = nullptr;  
      c_tempID.size = 0;      
    }

    if (temporaryID.isEmpty) {
      c_tempID.size = 0;
      c_tempID.buf = nullptr;
      return; 
    }

    c_tempID.buf = calloc<Uint8>(temporaryID.length);
    for (int i = 0; i < temporaryID.length; i++) {
      c_tempID.buf[i] = temporaryID[i];
    }
    c_tempID.size = temporaryID.length; 
  }

  void free(Pointer<OCTET_STRING> pointer) {
    if (pointer == nullptr) return;
    final c_tempID = pointer.ref;
    if (c_tempID.buf != nullptr) {
      calloc.free(c_tempID.buf);
      c_tempID.buf = nullptr;
      c_tempID.size = 0;
    }
  }
}