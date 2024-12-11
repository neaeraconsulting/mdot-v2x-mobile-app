import 'dart:ffi';
import 'package:cv_mec/models/J2735/AllowedManeuvers.dart';
import 'package:cv_mec/models/J2735/ApproachID.dart';
import 'package:cv_mec/models/J2735/ConnectsToList.dart';
import 'package:cv_mec/models/J2735/DescriptiveName.dart';
import 'package:cv_mec/models/J2735/LaneAttributes.dart';
import 'package:cv_mec/models/J2735/LaneID.dart';
import 'package:cv_mec/models/J2735/NodeListXY.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/OverlayLaneList.dart';

class GenericLane {
  late LaneID laneID;
  DescriptiveName? name;
  ApproachID? ingressApproach;
  ApproachID? egressApproach;
  late LaneAttributes laneAttributes;

  AllowedManeuvers? maneuvers;
  late NodeListXY nodeList;
  ConnectsToList? connectsTo;
  OverlayLaneList? overlays;

  GenericLane.fromC(C.GenericLane c_genericLane) {
    laneID = LaneID(c_genericLane.laneID);

    if (c_genericLane.name.address != 0) {
      name = DescriptiveName.fromOctetString(c_genericLane.name.ref);
    }

    if (c_genericLane.ingressApproach.address != 0) {
      ingressApproach = ApproachID(c_genericLane.ingressApproach.value);
    }

    if (c_genericLane.egressApproach.address != 0) {
      egressApproach = ApproachID(c_genericLane.egressApproach.value);
    }

    laneAttributes = LaneAttributes.fromC(c_genericLane.laneAttributes);

    if (c_genericLane.maneuvers.address != 0) {
      maneuvers = AllowedManeuvers.fromBitString(c_genericLane.maneuvers.ref);
    }

    nodeList = NodeListXY.fromC(c_genericLane.nodeList);

    if (c_genericLane.connectsTo.address != 0) {
      connectsTo = ConnectsToList.fromC(c_genericLane.connectsTo.ref);
    }

    if (c_genericLane.overlays.address != 0) {
      overlays = OverlayLaneList.fromC(c_genericLane.overlays.ref);
    }
  }
}
