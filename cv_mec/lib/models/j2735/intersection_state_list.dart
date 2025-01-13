import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/intersection_state.dart';

class IntersectionStateList {
  late List<IntersectionState> intersectionStateList;

  IntersectionStateList.fromC(C.IntersectionStateList c_intersectionStateList) {
    intersectionStateList = [];
    for (int i = 0; i < c_intersectionStateList.list.count; i++) {
      intersectionStateList.add(
          IntersectionState.fromC(c_intersectionStateList.list.array[i].ref));
    }
  }
}
