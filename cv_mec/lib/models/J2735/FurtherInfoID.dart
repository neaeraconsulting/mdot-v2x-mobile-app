import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_MsgID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class FurtherInfoId extends Choice_MsgID{
  late List<int> furtherInfoID;

  FurtherInfoId.fromOctetString(C.OCTET_STRING string){
    furtherInfoID = string.buf.asTypedList(string.size);
  }
}