import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_Description.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Circle.dart';
import 'package:cv_mec/models/J2735/Extent.dart';
import 'package:cv_mec/models/J2735/HeadingSlice.dart';
import 'package:cv_mec/models/J2735/LaneWidth.dart';
import 'package:cv_mec/models/J2735/RegionalExtension.dart';

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
