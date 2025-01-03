import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/j2735/movement_event.dart';

class MovementEventList {
  late List<MovementEvent> movementEventList;

  MovementEventList.fromC(C.MovementEventList c_movementEventList) {
    movementEventList = [];

    for (int i = 0; i < c_movementEventList.list.count; i++) {
      movementEventList
          .add(MovementEvent.fromC(c_movementEventList.list.array[i].ref));
    }
  }
}
