import 'dart:typed_data';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:ffi/ffi.dart';
import 'dart:ffi';

class PayUnit {
  late String payUnit;
  PayUnit.fromOctetString(C.OCTET_STRING_t string){
    final Uint8List byteList = string.buf.asTypedList(string.size);
    payUnit = String.fromCharCodes(byteList);
  }

  void toC(Pointer<C.PayUnit_t> pointer) {
    final c_payUnit = pointer.ref;
    
    // Convert string to bytes (treating as regular string, not hex)
    final bytes = payUnit.codeUnits;  // Get UTF-16 code units as bytes
    
    
    if (bytes.isNotEmpty) {
      c_payUnit.buf = calloc<Uint8>(bytes.length);
      c_payUnit.size = bytes.length;
      
      for (int i = 0; i < bytes.length; i++) {
        c_payUnit.buf[i] = bytes[i];
      }
    } else {
      c_payUnit.buf = nullptr;
      c_payUnit.size = 0;
    }
  }

  PayUnit(this.payUnit);
}