import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/semi_major_axis_accuracy.dart';
import 'package:cv_mec/models/j2735/semi_major_axis_orientation.dart';
import 'package:cv_mec/models/j2735/semi_minor_axis_accuracy.dart';

class PositionalAccuracy {
  late SemiMajorAxisAccuracy semiMajor;
  late SemiMinorAxisAccuracy semiMinor;
  late SemiMajorAxisOrientation orientation;

  PositionalAccuracy.fromC(C.PositionalAccuracy accuracy) {
    semiMajor = SemiMajorAxisAccuracy(accuracy.semiMajor);
    semiMinor = SemiMinorAxisAccuracy(accuracy.semiMinor);
    orientation = SemiMajorAxisOrientation(accuracy.orientation);
  }
}
