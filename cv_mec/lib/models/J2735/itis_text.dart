import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1_plugin/generated_bindings.dart';
import 'package:cv_mec/models/j2735/choice_item.dart';
import 'dart:ffi';

class ITIStext extends Choice_Item {
  late String itisText;

  ITIStext(this.itisText);

  ITIStext.fromOctetString(OCTET_STRING string) {
    // itisText = String.from
    final Uint8List byteList = string.buf.asTypedList(string.size);

    // Convert the byte list to a String (assuming UTF-8 encoding)
    itisText = utf8.decode(byteList);
  }
}
