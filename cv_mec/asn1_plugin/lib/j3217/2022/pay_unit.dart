import 'dart:typed_data';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:ffi/ffi.dart';
import 'dart:ffi';

class PayUnit {
  late String payUnit;
  PayUnit.fromOctetString(C.OCTET_STRING_t string){
    final Uint8List byteList = string.buf.asTypedList(string.size);

    payUnit = byteList.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
    print('PayUnit as hex: $payUnit');

  }

  void toC(Pointer<C.PayUnit_t> pointer) {
    final c_payUnit = pointer.ref;
    
    final bytes = hexStringToBytes(payUnit);  // Get UTF-16 code units as bytes
    
    
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

  List<int> hexStringToBytes(String hexString) {
    String cleanHex = hexString.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
    
    if (cleanHex.length % 2 != 0) {
      cleanHex = '0$cleanHex';
    }
    
    List<int> bytes = [];
    for (int i = 0; i < cleanHex.length; i += 2) {
      String hexByte = cleanHex.substring(i, i + 2);
      bytes.add(int.parse(hexByte, radix: 16));
    }
    
    return bytes;
  }

  PayUnit(this.payUnit);
}