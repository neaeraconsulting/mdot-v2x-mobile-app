import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/confidence.dart';
import 'package:cv_mec/models/j2735/radius_of_curvature.dart';

class PathPrediction {
  late RadiusOfCurvature radiusOfCurve;
  late Confidence confidence;

  PathPrediction.fromC(C.PathPrediction c_pathPrediction) {
    radiusOfCurve = RadiusOfCurvature(c_pathPrediction.radiusOfCurve);
    confidence = Confidence(c_pathPrediction.confidence);
  }
}
