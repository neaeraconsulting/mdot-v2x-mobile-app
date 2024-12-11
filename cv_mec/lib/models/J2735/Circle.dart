import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/DistanceUnits.dart';
import 'package:cv_mec/models/J2735/Position3D.dart';
import 'package:cv_mec/models/J2735/Radius_B12.dart';

class Circle {
  late Position3D center;
  late Radius_B12 radius;
  late DistanceUnits units;


  Circle.fromC(C.Circle circle){
    center = Position3D.fromC(circle.center);
    radius = Radius_B12(circle.radius);
    units = DistanceUnits.values[circle.units];
  }
}