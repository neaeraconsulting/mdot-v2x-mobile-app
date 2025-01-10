import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/d_date_time.dart';
import 'package:cv_mec/models/j2735/elevation.dart';
import 'package:cv_mec/models/j2735/heading.dart';
import 'package:cv_mec/models/j2735/latitude.dart';
import 'package:cv_mec/models/j2735/longitude.dart';
import 'package:cv_mec/models/j2735/position_confidence_set.dart';
import 'package:cv_mec/models/j2735/positional_accuracy.dart';
import 'package:cv_mec/models/j2735/speed_and_heading_and_throttle_confidence.dart';
import 'package:cv_mec/models/j2735/time_confidence.dart';
import 'package:cv_mec/models/j2735/transmission_and_speed.dart';

class FullPositionVector {
  DDateTime? utcTime;
  late Longitude long;
  late Latitude lat;
  Elevation? elevation;
  Heading? heading;
  TransmissionAndSpeed? speed;
  PositionalAccuracy? posAccuracy;
  TimeConfidence? timeConfidence;
  PositionConfidenceSet? posConfidence;
  SpeedandHeadingandThrottleConfidence? speedConfidence;

  FullPositionVector.fromC(C.FullPositionVector c_fullPositionVector) {
    if (c_fullPositionVector.utcTime.address != 0) {
      utcTime = DDateTime.fromC(c_fullPositionVector.utcTime.ref);
    }

    long = Longitude(c_fullPositionVector.Long);
    lat = Latitude(c_fullPositionVector.lat);

    if (c_fullPositionVector.elevation.address != 0) {
      elevation = Elevation(c_fullPositionVector.elevation.value);
    }

    if (c_fullPositionVector.heading.address != 0) {
      heading = Heading(c_fullPositionVector.heading.value);
    }

    if (c_fullPositionVector.speed.address != 0) {
      speed = TransmissionAndSpeed.fromC(c_fullPositionVector.speed.ref);
    }

    if (c_fullPositionVector.posAccuracy.address != 0) {
      posAccuracy =
          PositionalAccuracy.fromC(c_fullPositionVector.posAccuracy.ref);
    }

    if (c_fullPositionVector.timeConfidence.address != 0) {
      timeConfidence =
          TimeConfidence.values[c_fullPositionVector.timeConfidence.value];
    }

    if (c_fullPositionVector.speedConfidence.address != 0) {
      speedConfidence = SpeedandHeadingandThrottleConfidence.fromC(
          c_fullPositionVector.speedConfidence.ref);
    }
  }
}
