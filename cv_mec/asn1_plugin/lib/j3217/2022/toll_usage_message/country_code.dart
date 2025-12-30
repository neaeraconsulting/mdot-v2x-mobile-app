import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class CountryCode {
  final String value;
  CountryCode(C.CountryCode_t c_obj)
      : value = String.fromCharCodes(c_obj.buf.asTypedList(c_obj.size));
  
  void toC(Pointer<C.CountryCode_t> pointer) {
    final c_countryCode = pointer.ref;

    List<int> bytes = value.codeUnits;
    if (bytes.isNotEmpty) {
      c_countryCode.buf = calloc<Uint8>(bytes.length);
      c_countryCode.size = bytes.length;
      
      for (int i = 0; i < bytes.length; i++) {
        c_countryCode.buf[i] = bytes[i];
      }
    } else {
      c_countryCode.buf = nullptr;
      c_countryCode.size = 0;
    }
  }
}