import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/j2735/advisory_speed_type.dart';
import 'package:cv_mec/models/j2735/restriction_class_id.dart';
import 'package:cv_mec/models/j2735/speed_advice.dart';
import 'package:cv_mec/models/j2735/speed_confidence.dart';
import 'package:cv_mec/models/j2735/zone_length.dart';

class AdvisorySpeed {
  late AdvisorySpeedType type;
  SpeedAdvice? speed;
  SpeedConfidence? confidence;
  ZoneLength? distance;
  RestrictionClassID? restrictionClassId;

  AdvisorySpeed.fromC(C.AdvisorySpeed c_advisorySpeed) {
    type = AdvisorySpeedType.values[c_advisorySpeed.type];

    if (c_advisorySpeed.speed.address != 0) {
      speed = SpeedAdvice(c_advisorySpeed.speed.value);
    }

    if (c_advisorySpeed.confidence.address != 0) {
      confidence = SpeedConfidence.values[c_advisorySpeed.confidence.value];
    }

    if (c_advisorySpeed.distance.address != 0) {
      distance = ZoneLength(c_advisorySpeed.distance.value);
    }

    if (c_advisorySpeed.Class.address != 0) {
      restrictionClassId = RestrictionClassID(c_advisorySpeed.Class.address);
    }
  }
}
