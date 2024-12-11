import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_MsgID.dart';
import 'package:cv_mec/models/J2735/HeadingSlice.dart';
import 'package:cv_mec/models/J2735/MUTCDCode.dart';
import 'package:cv_mec/models/J2735/MsgCRC.dart';
import 'package:cv_mec/models/J2735/Position3D.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class RoadSignID extends Choice_MsgID {
  late Position3D position;
  late HeadingSlice viewAngle;
  MUTCDCode? mutcdCode;
  MsgCRC? crc;

  RoadSignID.fromC(C.RoadSignID roadSignID) {
    position = Position3D.fromC(roadSignID.position);
    viewAngle = HeadingSlice.fromBitString(roadSignID.viewAngle);

    if (roadSignID.mutcdCode.address != 0) {
      mutcdCode = MUTCDCode.values[roadSignID.mutcdCode.value];
    }

    if (roadSignID.crc.address != 0) {
      crc = MsgCRC.fromOctetString(roadSignID.crc.ref);
    }
  }
}
