import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_description.dart';
import 'package:cv_mec/models/j2735/descriptive_name.dart';
import 'package:cv_mec/models/j2735/direction_of_use.dart';
import 'package:cv_mec/models/j2735/geometric_projection.dart';
import 'package:cv_mec/models/j2735/heading_slice.dart';
import 'package:cv_mec/models/j2735/lane_width.dart';
import 'package:cv_mec/models/j2735/offset_system.dart';
import 'package:cv_mec/models/j2735/position_3d.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/regional_extension.dart';
import 'package:cv_mec/models/j2735/road_segment_reference_id.dart';

class GeographicalPath {
  DescriptiveName? name;
  RoadSegmentReferenceID? id;
  Position3D? anchor;
  LaneWidth? laneWidth;
  DirectionOfUse? directionality;
  bool? closedPath;
  HeadingSlice? direction;
  Choice_Description? description;
  List<RegionalExtension>? regional;

  GeographicalPath.fromC(C.GeographicalPath geographicalPath) {
    if (geographicalPath.name.address != 0) {
      name = DescriptiveName.fromOctetString(geographicalPath.name.ref);
    }

    if (geographicalPath.id.address != 0) {
      id = RoadSegmentReferenceID.fromC(geographicalPath.id.ref);
    }

    if (geographicalPath.anchor.address != 0) {
      anchor = Position3D.fromC(geographicalPath.anchor.ref);
    }

    if (geographicalPath.laneWidth.address != 0) {
      laneWidth = LaneWidth(geographicalPath.laneWidth.value);
    }

    if (geographicalPath.directionality.address != 0) {
      directionality =
          DirectionOfUse.values[geographicalPath.directionality.value];
    }

    if (geographicalPath.closedPath.address != 0) {
      closedPath = geographicalPath.closedPath.value == 0;
    }

    if (geographicalPath.direction.address != 0) {
      direction = HeadingSlice.fromBitString(geographicalPath.direction.ref);
    }

    if (geographicalPath.description.address != 0) {
      int choiceDescriptionID = geographicalPath.description.ref.present;
      if (choiceDescriptionID ==
          C.GeographicalPath__description_PR
              .GeographicalPath__description_PR_path) {
        description =
            OffsetSystem.fromC(geographicalPath.description.ref.choice.path);
      } else if (choiceDescriptionID ==
          C.GeographicalPath__description_PR
              .GeographicalPath__description_PR_geometry) {
        description = GeometricProjection.fromC(
            geographicalPath.description.ref.choice.geometry);
      } else if (choiceDescriptionID ==
          C.GeographicalPath__description_PR
              .GeographicalPath__description_PR_oldRegion) {
        print(
            "Received description of type oldRegion. This is no longer recommended for use and not supported");
        // description = ValidRegion.fromC(geographicalPath.description.ref.choice.oldRegion);
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
