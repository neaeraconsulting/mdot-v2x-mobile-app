import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;

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
}

class CountryCode {
  final String value;
  //BitString to string
  CountryCode(C.CountryCode_t c_obj)
      : value = String.fromCharCodes(c_obj.buf.asTypedList(c_obj.size));
  
  // You may need to add a toC method here too
}