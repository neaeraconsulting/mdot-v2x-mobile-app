import 'package:cv_mec/models/j2735/heading_slice.dart';
import 'package:dart_jts/dart_jts.dart';

class GeometryDirection {
  late Geometry geometry;
  HeadingSlice? direction;

  GeometryDirection(this.geometry, this.direction);
}
