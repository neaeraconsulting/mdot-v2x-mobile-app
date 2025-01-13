import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_msg_id.dart';
import 'package:cv_mec/models/j2735/heading_slice.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/msg_crc.dart';
import 'package:cv_mec/models/j2735/mutcd_code.dart';
import 'package:cv_mec/models/j2735/position_3d.dart';

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
