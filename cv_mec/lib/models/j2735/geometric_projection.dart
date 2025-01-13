import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_description.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/circle.dart';
import 'package:cv_mec/models/j2735/extent.dart';
import 'package:cv_mec/models/j2735/heading_slice.dart';
import 'package:cv_mec/models/j2735/lane_width.dart';
import 'package:cv_mec/models/j2735/regional_extension.dart';

class GeometricProjection extends Choice_Description {
  late HeadingSlice direction;
  Extent? extent;
  LaneWidth? laneWidth;
  late Circle circle;

  List<RegionalExtension>? regional;

  GeometricProjection.fromC(C.GeometricProjection geometricProjection) {
    direction = HeadingSlice.fromBitString(geometricProjection.direction);

    if (geometricProjection.extent.address != 0) {
      extent = Extent.values[geometricProjection.extent.value];
    }

    if (geometricProjection.laneWidth.address != 0) {
      laneWidth = LaneWidth(geometricProjection.laneWidth.value);
    }

    circle = Circle.fromC(geometricProjection.circle);
  }
}
