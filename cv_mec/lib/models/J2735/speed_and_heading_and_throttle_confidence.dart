import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/heading_confidence.dart';
import 'package:cv_mec/models/j2735/speed_confidence.dart';
import 'package:cv_mec/models/j2735/throttle_confidence.dart';

class SpeedandHeadingandThrottleConfidence {
  late HeadingConfidence heading;
  late SpeedConfidence speed;
  late ThrottleConfidence throttle;

  SpeedandHeadingandThrottleConfidence.fromC(
      C.SpeedandHeadingandThrottleConfidence
          c_speedAndHeadingThrottleConfidence) {
    heading =
        HeadingConfidence.values[c_speedAndHeadingThrottleConfidence.heading];
    speed = SpeedConfidence.values[c_speedAndHeadingThrottleConfidence.speed];
    throttle =
        ThrottleConfidence.values[c_speedAndHeadingThrottleConfidence.throttle];
  }
}
