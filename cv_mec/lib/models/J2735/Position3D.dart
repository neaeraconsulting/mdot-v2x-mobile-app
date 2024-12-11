import 'dart:ffi';

import 'package:cv_mec/models/J2735/Elevation.dart';
import 'package:cv_mec/models/J2735/Latitude.dart';
import 'package:cv_mec/models/J2735/Longitude.dart';
import 'package:cv_mec/models/J2735/RegionalExtension.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;

class Position3D {
  late Latitude lat;
  late Longitude long;
  Elevation? elevation;
  List<RegionalExtension>? regional;

  Position3D.fromC(C.Position3D position3D) {
    lat = Latitude(position3D.lat);
    long = Longitude(position3D.Long);

    if (position3D.elevation.address != 0) {
      elevation = Elevation(position3D.elevation.value);
    }

    // if(position3D.regional.address != 0){
    //   regional = [];
    //   for(int i=0; i< position3D.regional.ref.list.count; i++){
    //     regional.add(RegionalExtension.fromC(position3D.regional.ref.list.array[i]));
    //   }
    // }
  }
}
