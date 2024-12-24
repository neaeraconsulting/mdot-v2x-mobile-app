import 'package:cv_mec/models/j2735/movement_phase_state.dart';
import 'package:cv_mec/models/j2735/time_change_details.dart';

class LightChangeTime {
  late DateTime minEndTime;
  DateTime? maxEndTime;
  DateTime? likelyTime;
  late MovementPhaseState currentPhaseState;

  LightChangeTime(TimeChangeDetails timeChangeDetails, DateTime referenceTime,
      MovementPhaseState state) {
    currentPhaseState = state;
    minEndTime = timeChangeDetails.minEndTime.getUtcTime(referenceTime);

    if (timeChangeDetails.maxEndTime != null) {
      maxEndTime = timeChangeDetails.maxEndTime!.getUtcTime(referenceTime);
    }

    if (timeChangeDetails.likelyTime != null) {
      likelyTime = timeChangeDetails.likelyTime!.getUtcTime(referenceTime);
    }
  }
}
