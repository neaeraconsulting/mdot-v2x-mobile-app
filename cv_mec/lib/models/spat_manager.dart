import 'package:cv_mec/models/J2735/IntersectionReferenceID.dart';
import 'package:cv_mec/models/J2735/IntersectionState.dart';
import 'package:cv_mec/models/J2735/Spat.dart';

class SpatManager {
  Map<int, Spat> storedSpats = <int, Spat>{};
  Map<int, IntersectionState> storedIntersections = <int, IntersectionState>{};

  void addOrUpdate(Spat spat) {
    for (IntersectionState state in spat.intersections.intersectionStateList) {
      int stateId = state.id.id.intersectionID;
      if (storedIntersections.containsKey(stateId)) {
        if (state
            .getUtcTime()
            .isAfter(storedIntersections[stateId]!.getUtcTime())) {
          storedSpats[stateId] = spat;
          storedIntersections[stateId] = state;
        }
      } else {
        storedSpats[stateId] = spat;
        storedIntersections[stateId] = state;
      }
    }
  }

  void removeSpatByIntersectionReference(IntersectionReferenceID spatKey) {
    if (storedSpats.containsKey(spatKey)) {
      storedSpats.remove(spatKey);
    }

    if (storedIntersections.containsKey(spatKey)) {
      storedIntersections.remove(spatKey);
    }
  }

  void removeSpat(Spat spat) {
    for (IntersectionState state in spat.intersections.intersectionStateList) {
      if (storedIntersections.containsKey(state.id)) {
        storedIntersections.remove(state.id);
      }

      if (storedSpats.containsKey(state.id)) {
        storedSpats.remove(state.id);
      }
    }
  }

  List<IntersectionState> getActiveSpats(int spatKey, DateTime now) {
    List<IntersectionState> states = [];

    if (storedSpats.containsKey(spatKey)) {
      Spat spat = storedSpats[spatKey]!;

      for (IntersectionState state
          in spat.intersections.intersectionStateList) {
        if (state.getUtcTime().isAfter(now.subtract(Duration(seconds: 1))) &&
            state.getUtcTime().isBefore(now.add(Duration(seconds: 1)))) {
          states.add(state);
        }
      }
    }
    return states;
  }
}
