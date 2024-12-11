import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_LaneTypeAttributes.dart';
import 'package:cv_mec/models/J2735/LaneAttributesCrosswalk.dart';
import 'package:cv_mec/models/J2735/LaneAttributesVehicle.dart';
import 'package:cv_mec/models/J2735/LaneAttributesBike.dart';
import 'package:cv_mec/models/J2735/LaneAttributesSidewalk.dart';
import 'package:cv_mec/models/J2735/LaneAttributesBarrier.dart';
import 'package:cv_mec/models/J2735/LaneAttributesStriping.dart';
import 'package:cv_mec/models/J2735/LaneAttributesTrackedVehicle.dart';
import 'package:cv_mec/models/J2735/LaneAttributesParking.dart';
import 'package:cv_mec/models/J2735/LaneDirection.dart';
import 'package:cv_mec/models/J2735/LaneSharing.dart';

class LaneAttributes{
  late LaneDirection directionalUse;
  late LaneSharing sharedWith;
  late Choice_LaneTypeAttributes laneType;

  LaneAttributes.fromC(C.LaneAttributes c_laneAttributes){
    directionalUse = LaneDirection.fromBitString(c_laneAttributes.directionalUse);
    
    sharedWith = LaneSharing.fromBitString(c_laneAttributes.sharedWith);

    if(c_laneAttributes.laneType.present == 1){
      laneType = LaneAttributesVehicle.fromBitString(c_laneAttributes.laneType.choice.vehicle);
    }else if(c_laneAttributes.laneType.present == 2){
      laneType = LaneAttributesCrosswalk.fromBitString(c_laneAttributes.laneType.choice.crosswalk);
    }else if(c_laneAttributes.laneType.present == 3){
      laneType = LaneAttributesBike.fromBitString(c_laneAttributes.laneType.choice.bikeLane);
    }else if(c_laneAttributes.laneType.present == 4){
      laneType = LaneAttributesSidewalk.fromBitString(c_laneAttributes.laneType.choice.sidewalk);
    }else if(c_laneAttributes.laneType.present == 5){
      laneType = LaneAttributesBarrier.fromBitString(c_laneAttributes.laneType.choice.median);
    }else if(c_laneAttributes.laneType.present == 6){
      laneType = LaneAttributesStriping.fromBitString(c_laneAttributes.laneType.choice.striping);
    }else if(c_laneAttributes.laneType.present == 7){
      laneType = LaneAttributesTrackedVehicle.fromBitString(c_laneAttributes.laneType.choice.trackedVehicle);
    }else if(c_laneAttributes.laneType.present == 8){
      laneType = LaneAttributesParking.fromBitString(c_laneAttributes.laneType.choice.parking);
    }
  }

}