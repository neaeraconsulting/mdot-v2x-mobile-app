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
    
    // Free previous buffer if needed
    if (c_tempID.buf != nullptr && c_tempID.size > 0) {
      calloc.free(c_tempID.buf);
      c_tempID.buf = nullptr;  // Reset pointer
      c_tempID.size = 0;       // Reset size
    }

    if (temporaryID.isEmpty) {
      c_tempID.size = 0;
      c_tempID.buf = nullptr;
      return; // Just return without a value
    }

    // Use correct allocation method
    c_tempID.buf = calloc<Uint8>(temporaryID.length);
    for (int i = 0; i < temporaryID.length; i++) {
      c_tempID.buf[i] = temporaryID[i];
    }
    c_tempID.size = temporaryID.length; 
  }
}