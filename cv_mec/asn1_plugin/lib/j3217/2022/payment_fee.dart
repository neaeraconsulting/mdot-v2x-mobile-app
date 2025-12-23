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
    
    // Clean up existing allocations first
    _cleanupExistingAllocations(c_paymentFee);
    
    // Zero-initialize the struct
    pointer.cast<Uint8>().asTypedList(sizeOf<C.PaymentFee>()).fillRange(0, sizeOf<C.PaymentFee>(), 0);
    
    // Handle paymentFeeAmount (direct int field)
    c_paymentFee.paymentFeeAmount = paymentFeeAmount;
    
    final paymentFeeUnitPtr = calloc<C.PayUnit_t>();
    paymentFeeUnitPtr.cast<Uint8>().asTypedList(sizeOf<C.PayUnit_t>()).fillRange(0, sizeOf<C.PayUnit_t>(), 0);
    paymentFeeUnit.toC(paymentFeeUnitPtr);
    c_paymentFee.paymentFeeUnit = paymentFeeUnitPtr.ref;
  }


  void _cleanupExistingAllocations(C.PaymentFee c_paymentFee) {
    // Clean up paymentFeeUnit buffer
    if (c_paymentFee.paymentFeeUnit.buf != nullptr) {
      calloc.free(c_paymentFee.paymentFeeUnit.buf);
      c_paymentFee.paymentFeeUnit.buf = nullptr;
      c_paymentFee.paymentFeeUnit.size = 0;
    }
  }

  PaymentFee(this.paymentFeeAmount, String payUnitStr){
    paymentFeeUnit = PayUnit(payUnitStr);
  }
}
 