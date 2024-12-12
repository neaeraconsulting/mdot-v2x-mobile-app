import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/SemiMajorAxisAccuracy.dart';
import 'package:cv_mec/models/J2735/SemiMajorAxisOrientation.dart';
import 'package:cv_mec/models/J2735/SemiMinorAxisAccuracy.dart';

class PositionalAccuracy{
  late SemiMajorAxisAccuracy semiMajor;
  late SemiMinorAxisAccuracy semiMinor;
  late SemiMajorAxisOrientation orientation;


  PositionalAccuracy.fromC(C.PositionalAccuracy accuracy){
    semiMajor = SemiMajorAxisAccuracy(accuracy.semiMajor);
    semiMinor = SemiMinorAxisAccuracy(accuracy.semiMinor);
    orientation = SemiMajorAxisOrientation(accuracy.orientation);
  }
}