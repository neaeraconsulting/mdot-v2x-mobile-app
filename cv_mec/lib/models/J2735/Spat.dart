import 'dart:ffi';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/J2735.dart';

class Spat {
  MinuteOfTheYear? timeStamp;
  DescriptiveName? name;
  late IntersectionStateList intersections;

  Spat.fromC(C.SPAT c_spat) {
    if (c_spat.timeStamp.address != 0) {
      timeStamp = MinuteOfTheYear(c_spat.timeStamp.value);
    }

    if (c_spat.name.address != 0) {
      name = DescriptiveName.fromOctetString(c_spat.name.ref);
    }

    intersections = IntersectionStateList.fromC(c_spat.intersections);
  }
}
