import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

import 'package:cv_mec/models/J2735/AdvisorySpeedType.dart';
import 'package:cv_mec/models/J2735/RestrictionClassID.dart';
import 'package:cv_mec/models/J2735/SpeedAdvice.dart';
import 'package:cv_mec/models/J2735/SpeedConfidence.dart';
import 'package:cv_mec/models/J2735/ZoneLength.dart';

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
