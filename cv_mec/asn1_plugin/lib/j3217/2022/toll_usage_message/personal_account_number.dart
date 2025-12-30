import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class PersonalAccountNumber{
  late String pan;
  PersonalAccountNumber(Pointer<C.OCTET_STRING> c_obj){
    final byteList = c_obj.ref.buf.asTypedList(c_obj.ref.size);
    pan = String.fromCharCodes(byteList);
  }
}