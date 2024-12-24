import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_description.dart';
import 'package:cv_mec/models/j2735/choice_offset.dart';
import 'package:cv_mec/models/j2735/node_list_ll.dart';
import 'package:cv_mec/models/j2735/node_list_xy.dart';
import 'package:cv_mec/models/j2735/zoom.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class OffsetSystem extends Choice_Description {
  Zoom? scale;
  late Choice_Offset offset;

  OffsetSystem.fromC(C.OffsetSystem offsetSystem) {
    if (offsetSystem.scale.address != 0) {
      scale = Zoom(offsetSystem.scale.value);
    }

    int choiceOffset = offsetSystem.offset.present;

    if (choiceOffset == 1) {
      offset = NodeListXY.fromC(offsetSystem.offset.choice.xy);
    } else if (choiceOffset == 2) {
      offset = NodeListLL.fromC(offsetSystem.offset.choice.ll);
    } else {
      print("Choice Offset $choiceOffset is invalid for OffsetSystem");
    }
  }
}
