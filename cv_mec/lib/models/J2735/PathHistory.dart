import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/FullPositionVector.dart';
import 'package:cv_mec/models/J2735/GNSSstatus.dart';
import 'package:cv_mec/models/J2735/PathHistoryPointList.dart';

class PathHistory {
  FullPositionVector? initialPosition;
  GNSSstatus? currGNSStatus;
  late PathHistoryPointList crumbData;

  PathHistory.fromC(C.PathHistory c_pathHistory) {
    if (c_pathHistory.initialPosition.address != 0) {
      initialPosition =
          FullPositionVector.fromC(c_pathHistory.initialPosition.ref);
    }

    if (c_pathHistory.currGNSSstatus.address != 0) {
      currGNSStatus =
          GNSSstatus.fromBitString(c_pathHistory.currGNSSstatus.ref);
    }

    crumbData = PathHistoryPointList.fromC(c_pathHistory.crumbData);
  }
}
