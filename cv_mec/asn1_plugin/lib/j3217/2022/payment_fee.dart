import 'dart:ffi';
import 'dart:typed_data';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/pay_unit.dart';
import 'package:ffi/ffi.dart';

class PaymentFee {
  late int paymentFeeAmount;
  late PayUnit paymentFeeUnit;
  PaymentFee.fromC(C.PaymentFee c_obj){
    paymentFeeAmount = c_obj.paymentFeeAmount;
    paymentFeeUnit = PayUnit.fromOctetString(c_obj.paymentFeeUnit);
  }

  void toC(Pointer<C.PaymentFee> pointer) {
    final c_paymentFee = pointer.ref;
    
    pointer.cast<Uint8>().asTypedList(sizeOf<C.PaymentFee>()).fillRange(0, sizeOf<C.PaymentFee>(), 0);
    
    c_paymentFee.paymentFeeAmount = paymentFeeAmount;
    
    final paymentFeeUnitPtr = calloc<C.PayUnit_t>();
    paymentFeeUnitPtr.cast<Uint8>().asTypedList(sizeOf<C.PayUnit_t>()).fillRange(0, sizeOf<C.PayUnit_t>(), 0);
    paymentFeeUnit.toC(paymentFeeUnitPtr);
    c_paymentFee.paymentFeeUnit = paymentFeeUnitPtr.ref;
  }


  void free(Pointer<C.PaymentFee> pointer) {    
    calloc.free(pointer);
  }

  PaymentFee(this.paymentFeeAmount, String payUnitStr){
    paymentFeeUnit = PayUnit(payUnitStr);
  }

  (double, int) getPaymentAmountWithUnit() {
    double amount = paymentFeeAmount.toDouble();
    String payUnitStr = paymentFeeUnit.payUnit;
    
    String factor = payUnitStr.substring(0, 1);
    
    switch (factor) {
      case "0":
        break;
      case "1":
        amount *= 10;
        break;
      case "2":
        amount *= 100;
        break;
      case "3":
        amount *= 1000;
        break;
      case "4":
        amount /= 10;
        break;
      case "5":
        amount /= 100;
        break;
      case "6":
        amount /= 1000;
        break;
      default:
        break;
    }
    
    int unit = int.parse(payUnitStr.substring(1));
    return (amount, unit);
  }
}
 