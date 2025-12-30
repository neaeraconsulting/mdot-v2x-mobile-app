import 'dart:convert';
import 'dart:typed_data';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:asn1_plugin/generated_bindings.dart' as C;
class DescriptiveName{
  late String descriptiveName;

  DescriptiveName.fromOctetString(C.OCTET_STRING string ){
    final Uint8List byteList = string.buf.asTypedList(string.size);

    // Convert the byte list to a String (assuming UTF-8 encoding)
    descriptiveName = utf8.decode(byteList);
  }

  Pointer<C.OCTET_STRING> toC(Pointer<C.OCTET_STRING> pointer) {
    final c_name = pointer.ref;

    // Free previous buffer if present
    if (c_name.buf != nullptr && c_name.size > 0) {
      calloc.free(c_name.buf);
      c_name.buf = nullptr;
      c_name.size = 0;
    }

    final utf8Bytes = utf8.encode(descriptiveName);
    if (utf8Bytes.isEmpty) {
      c_name.buf = nullptr;
      c_name.size = 0;
      return pointer;
    }

    final buf = calloc.allocate<Uint8>(utf8Bytes.length);
    for (int i = 0; i < utf8Bytes.length; i++) {
      buf[i] = utf8Bytes[i];
    }

    c_name.buf = buf;
    c_name.size = utf8Bytes.length;
    return pointer;
  }
}