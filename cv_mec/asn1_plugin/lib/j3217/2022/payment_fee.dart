import 'dart:ffi';
import 'dart:typed_data';

import 'package:asn1_plugin/generated_bindings.dart' as C;

class PaymentFee {
  late int paymentFeeAmount;
  late PayUnit paymentFeeUnit;
  PaymentFee.fromC(C.PaymentFee c_obj){
    paymentFeeAmount = c_obj.paymentFeeAmount;
    paymentFeeUnit = PayUnit.fromOctetString(c_obj.paymentFeeUnit);
  }
}

class PayUnit {
  late String payUnit;
  PayUnit.fromOctetString(C.OCTET_STRING_t string){
    final Uint8List byteList = string.buf.asTypedList(string.size);
    payUnit = String.fromCharCodes(byteList);
  }
}

// class DescriptiveName{
//   late String descriptiveName;

//   DescriptiveName.fromOctetString(C.OCTET_STRING string ){
//     final Uint8List byteList = string.buf.asTypedList(string.size);

//     // Convert the byte list to a String (assuming UTF-8 encoding)
//     descriptiveName = utf8.decode(byteList);
//   }
// }

// class PayUnit {
//   late String unit;
//   PayUnit.fromOctetString(OCTET_STRING string){
//     unit = String.fromCharCodes(string.buf.asTypedList(string.size));
//   }
// }

// class TumPublicKeyOctetString {
//   late C.OCTET_STRING_t tumPublicKeyOctetString;
//   TumPublicKeyOctetString(C.OCTET_STRING_t value): tumPublicKeyOctetString = value;
// }

// class TemporaryID{
//   late List<int> temporaryID;

//   TemporaryID.fromOctetString(OCTET_STRING string){
//     temporaryID = string.buf.asTypedList(string.size);
//   }


//   void toOctetString(OCTET_STRING string){
//     for (int i = 0; i < temporaryID.length; i++) {
//       string.buf[i] = temporaryID[i];
//     }
//     // string.size = temporaryID.length;
//   }
// }