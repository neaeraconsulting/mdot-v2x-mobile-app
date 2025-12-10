import 'dart:ffi';
import 'dart:typed_data';

import 'package:asn1_plugin/generated_bindings.dart' as C;
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


  // Helper method to clean up existing allocations
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

class PayUnit {
  late String payUnit;
  PayUnit.fromOctetString(C.OCTET_STRING_t string){
    final Uint8List byteList = string.buf.asTypedList(string.size);
    payUnit = String.fromCharCodes(byteList);
  }

  void toC(Pointer<C.PayUnit_t> pointer) {
    final c_payUnit = pointer.ref;
    
    // Clean up existing allocation
    if (c_payUnit.buf != nullptr) {
      calloc.free(c_payUnit.buf);
      c_payUnit.buf = nullptr;
      c_payUnit.size = 0;
    }


    // Convert hexadecimal to octet string - Might need to take out if the incoming TAM changes their payment fee unit to actually be an octet string
    // String octetString = "";
    // for (int i = 0; i < payUnit.length-1; i += 2) {
    //   // This assumes payUnit is a hex string; adjust if it's not
    //   octetString += String.fromCharCode(int.parse(payUnit.substring(i, i + 2), radix: 16));
    // }
    
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

  PayUnit(String payUnit){
    this.payUnit = payUnit;
  }
}
 