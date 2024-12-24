import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/descriptive_name.dart';
import 'package:cv_mec/models/j2735/maneuver_assist_list.dart';
import 'package:cv_mec/models/j2735/movement_event_list.dart';
import 'dart:ffi';
import 'package:cv_mec/models/j2735/signal_group_id.dart';

class MovementState {
  DescriptiveName? movementName;
  late SignalGroupID signalGroup;
  late MovementEventList state_time_speed;
  ManeuverAssistList? maneuverAssistList;

  MovementState.fromC(C.MovementState c_movementState) {
    if (c_movementState.movementName.address != 0) {
      movementName =
          DescriptiveName.fromOctetString(c_movementState.movementName.ref);
    }

    signalGroup = SignalGroupID(c_movementState.signalGroup);

    state_time_speed =
        MovementEventList.fromC(c_movementState.state_time_speed);

    if (c_movementState.maneuverAssistList.address != 0) {
      maneuverAssistList =
          ManeuverAssistList.fromC(c_movementState.maneuverAssistList.ref);
    }
  }
}
