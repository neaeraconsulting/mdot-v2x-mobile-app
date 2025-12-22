import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
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
    
    // Clean up existing allocations first
    _cleanupExistingAllocations(c_lpn);
    
    // Zero-initialize the struct
    pointer.cast<Uint8>().asTypedList(sizeOf<C.Lpn>()).fillRange(0, sizeOf<C.Lpn>(), 0);
    
    // Handle countryCode (struct value, not pointer)
    if (countryCode != null) {
      countryCode!.toC(Pointer.fromAddress(pointer.address + 0)); // Assuming countryCode is first field
    }
    
    // Handle alphabetIndicator (direct int value)
    c_lpn.alphabetIndicator = alphabetIndicator ?? 0;
    
    // Handle licencePlateNumber (OCTET_STRING)
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
  
  void _cleanupExistingAllocations(C.Lpn c_lpn) {
    // Clean up licencePlateNumber buffer
    if (c_lpn.licencePlateNumber.buf != nullptr) {
      calloc.free(c_lpn.licencePlateNumber.buf);
      c_lpn.licencePlateNumber.buf = nullptr;
      c_lpn.licencePlateNumber.size = 0;
    }
  }
}

class CountryCode {
  final String value;
  //BitString to string
  CountryCode(C.CountryCode_t c_obj)
      : value = String.fromCharCodes(c_obj.buf.asTypedList(c_obj.size));
  
  void toC(Pointer<C.CountryCode_t> pointer) {
    final c_countryCode = pointer.ref;
    
    // Clean up existing allocation
    if (c_countryCode.buf != nullptr) {
      calloc.free(c_countryCode.buf);
      c_countryCode.buf = nullptr;
      c_countryCode.size = 0;
    }
    
    // Convert string to bytes
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