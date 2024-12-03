import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_Description.dart';
import 'package:cv_mec/models/J2735/DescriptiveName.dart';
import 'package:cv_mec/models/J2735/DirectionOfUse.dart';
import 'package:cv_mec/models/J2735/GeometricProjection.dart';
import 'package:cv_mec/models/J2735/HeadingSlice.dart';
import 'package:cv_mec/models/J2735/LaneWidth.dart';
import 'package:cv_mec/models/J2735/OffsetSystem.dart';
import 'package:cv_mec/models/J2735/Position3D.dart';
import 'package:cv_mec/models/J2735/RegionalExtension.dart';
import 'package:cv_mec/models/J2735/RoadSegmentReferenceID.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;


class GeographicalPath {
  late DescriptiveName? name;
  late RoadSegmentReferenceID? id;
  late Position3D? anchor;
  late LaneWidth? laneWidth;
  late DirectionOfUse? directionality;
  late bool? closedPath;
  late HeadingSlice? direction;
  late Choice_Description? description;
  late List<RegionalExtension>? regional;

  GeographicalPath.fromC(C.GeographicalPath geographicalPath){
    if(geographicalPath.name.address != 0){
      name = DescriptiveName.fromOctetString(geographicalPath.name.ref);
    }

    if(geographicalPath.id.address != 0){
      id = RoadSegmentReferenceID.fromC(geographicalPath.id.ref);
    }

    if(geographicalPath.anchor.address != 0){
      anchor = Position3D.fromC(geographicalPath.anchor.ref);
    }

    if(geographicalPath.laneWidth.address != 0){
      laneWidth = LaneWidth(geographicalPath.laneWidth.value);
    }

    if(geographicalPath.directionality.address != 0){
      directionality = DirectionOfUse.values[geographicalPath.directionality.value];
    }

    if(geographicalPath.closedPath.address != 0){
      closedPath = geographicalPath.closedPath.value == 0;
    }

    if(geographicalPath.direction.address != 0){
      direction = HeadingSlice.fromBitString(geographicalPath.direction.ref);
    }

    if(geographicalPath.description.address != 0){
      int choiceDescriptionID = geographicalPath.description.ref.present;
      if(choiceDescriptionID == 1){
        description = OffsetSystem.fromC(geographicalPath.description.ref.choice.path);
      }else if(choiceDescriptionID == 2){
        description = GeometricProjection.fromC(geographicalPath.description.ref.choice.geometry);
      }
      else if(choiceDescriptionID == 3){
        print("Received description of type oldRegion. This is no longer recommended for use and not supported");
        // description = ValidRegion.fromC(geographicalPath.description.ref.choice.oldRegion); // Legac
      }

    }

    // if(geographicalPath.regional.address != 0){
    //   regional = [];
    //   for(int i=0; i< geographicalPath.regional.ref.list.count; i++){
    //     regional.add(RegionalExtension.fromC(geographicalPath.regional.ref.list.array[i]));
    //   }
    // }
  }
}