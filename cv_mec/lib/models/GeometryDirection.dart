import 'package:cv_mec/models/J2735/HeadingSlice.dart';
import 'package:dart_jts/dart_jts.dart';

class GeometryDirection {
  late Geometry geometry;
  HeadingSlice? direction;

  GeometryDirection(this.geometry, this.direction);
}
