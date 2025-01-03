import 'package:cv_mec/models/j2735/allowed_maneuvers.dart';
import 'package:cv_mec/models/j2735/lane_id.dart';

import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class ConnectingLane {
  late LaneID lane;
  AllowedManeuvers? maneuver;

  ConnectingLane.fromC(C.ConnectingLane c_connectingLane) {
    lane = LaneID(c_connectingLane.lane);

    if (c_connectingLane.maneuver.address != 0) {
      maneuver = AllowedManeuvers.fromBitString(c_connectingLane.maneuver.ref);
    }
  }
}
