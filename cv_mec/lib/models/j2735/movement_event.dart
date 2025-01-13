import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/advisory_speed_list.dart';
import 'dart:ffi';

import 'package:cv_mec/models/j2735/movement_phase_state.dart';
import 'package:cv_mec/models/j2735/time_change_details.dart';

class MovementEvent {
  late MovementPhaseState eventState;
  TimeChangeDetails? timing;
  AdvisorySpeedList? speeds;

  MovementEvent.fromC(C.MovementEvent c_movementEvent) {
    eventState = MovementPhaseState.values[c_movementEvent.eventState];

    if (c_movementEvent.timing.address != 0) {
      timing = TimeChangeDetails.fromC(c_movementEvent.timing.ref);
    }

    if (c_movementEvent.speeds.address != 0) {
      speeds = AdvisorySpeedList.fromC(c_movementEvent.speeds.ref);
    }
  }
}
