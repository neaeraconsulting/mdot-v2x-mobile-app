import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/Choice_LaneDataAttribute.dart';
import 'package:cv_mec/models/J2735/DeltaAngle.dart';
import 'package:cv_mec/models/J2735/MergeDivergeNodeAngle.dart';
import 'package:cv_mec/models/J2735/RoadwayCrownAngle.dart';

import 'package:cv_mec/models/J2735/SpeedLimitList.dart';

class LaneDataAttribute{
  late Choice_LaneDataAttribute choice;

  LaneDataAttribute.fromC(C.LaneDataAttribute laneDataAttribute){

    if(laneDataAttribute.present ==1){
      choice = DeltaAngle(laneDataAttribute.choice.pathEndPointAngle);
    }else if(laneDataAttribute.present == 2){
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointCenter);
    }else if(laneDataAttribute.present == 3){
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointLeft);
    }else if(laneDataAttribute.present == 4){
      choice = RoadwayCrownAngle(laneDataAttribute.choice.laneCrownPointRight);
    }else if(laneDataAttribute.present == 5){
      choice = MergeDivergeNodeAngle(laneDataAttribute.choice.laneAngle);
    }else if(laneDataAttribute.present == 6){
      choice = SpeedLimitList.fromC(laneDataAttribute.choice.speedLimits);
    }else{
      print("Choice LaneDataAttribute ${laneDataAttribute.present} is invalid for LaneDataAttribute");
    }


  }
}