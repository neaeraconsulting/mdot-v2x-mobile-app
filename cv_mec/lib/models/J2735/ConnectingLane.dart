import 'package:cv_mec/models/J2735/AllowedManeuvers.dart';
import 'package:cv_mec/models/J2735/LaneID.dart';

import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class ConnectingLane {
  late LaneID lane;
  AllowedManeuvers? maneuver;

  ConnectingLane.fromC(C.ConnectingLane c_connectingLane) {
    lane = LaneID(c_connectingLane.lane);

    if (c_connectingLane.maneuver != 0) {
      maneuver = AllowedManeuvers.fromBitString(c_connectingLane.maneuver.ref);
    }
  }
}
