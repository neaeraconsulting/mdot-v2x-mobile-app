import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/j2735/segment_attribute_ll.dart';

class SegmentAttributeLLList {
  late List<SegmentAttributeLL> segmentAttributeLLList;

  SegmentAttributeLLList.fromC(C.SegmentAttributeLLList segmentAttributeList) {
    for (int i = 0; i < segmentAttributeList.list.count; i++) {
      segmentAttributeLLList.add(
          SegmentAttributeLL.values[segmentAttributeList.list.array[i].value]);
    }
  }
}
