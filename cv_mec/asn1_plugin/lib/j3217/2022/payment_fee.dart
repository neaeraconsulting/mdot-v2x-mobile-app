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