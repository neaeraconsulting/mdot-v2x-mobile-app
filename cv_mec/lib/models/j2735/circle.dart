import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/distance_units.dart';
import 'package:cv_mec/models/j2735/position_3d.dart';
import 'package:cv_mec/models/j2735/radius_b12.dart';

class Circle {
  late Position3D center;
  late Radius_B12 radius;
  late DistanceUnits units;

  Circle.fromC(C.Circle circle) {
    center = Position3D.fromC(circle.center);
    radius = Radius_B12(circle.radius);
    units = DistanceUnits.values[circle.units];
  }
}
