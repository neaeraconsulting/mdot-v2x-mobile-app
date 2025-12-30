import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/toll_usage_message/country_code.dart';
import 'package:ffi/ffi.dart';

class Lpn {
  CountryCode? countryCode;
  int? alphabetIndicator;
  String? licencePlate;
  
  Lpn.fromC(C.Lpn c_obj){
    countryCode = CountryCode(c_obj.countryCode);
    alphabetIndicator = c_obj.alphabetIndicator;
    if(c_obj.licencePlateNumber.buf != nullptr && c_obj.licencePlateNumber.size > 0){
        final byteList = c_obj.licencePlateNumber.buf.asTypedList(c_obj.licencePlateNumber.size);
        licencePlate = String.fromCharCodes(byteList);
    }  
  }

  void toC(Pointer<C.Lpn> pointer) {
    final c_lpn = pointer.ref;
    
    pointer.cast<Uint8>().asTypedList(sizeOf<C.Lpn>()).fillRange(0, sizeOf<C.Lpn>(), 0);
    
    // struct value, not pointer
    if (countryCode != null) {
      countryCode!.toC(Pointer.fromAddress(pointer.address + 0)); 
    }
    
    c_lpn.alphabetIndicator = alphabetIndicator ?? 0;
    
    if (licencePlate != null) {
      List<int> bytes = licencePlate!.codeUnits;
      if (bytes.isNotEmpty) {
        c_lpn.licencePlateNumber.buf = calloc<Uint8>(bytes.length);
        c_lpn.licencePlateNumber.size = bytes.length;
        
        for (int i = 0; i < bytes.length; i++) {
          c_lpn.licencePlateNumber.buf[i] = bytes[i];
        }
      } else {
        c_lpn.licencePlateNumber.buf = nullptr;
        c_lpn.licencePlateNumber.size = 0;
      }
    } else {
      c_lpn.licencePlateNumber.buf = nullptr;
      c_lpn.licencePlateNumber.size = 0;
    }
  }

  void free(Pointer<C.Lpn> pointer) {
    final c_lpn = pointer.ref;
    
    if (c_lpn.licencePlateNumber.buf != nullptr) {
      calloc.free(c_lpn.licencePlateNumber.buf);
      c_lpn.licencePlateNumber.buf = nullptr;
      c_lpn.licencePlateNumber.size = 0;
    }
    
    calloc.free(pointer);
  }
}