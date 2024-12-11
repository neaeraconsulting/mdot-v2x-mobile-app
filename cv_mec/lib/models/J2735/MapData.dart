import 'dart:ffi';
import 'package:cv_mec/models/J2735/DataParameters.dart';
import 'package:cv_mec/models/J2735/IntersectionGeometryList.dart';
import 'package:cv_mec/models/J2735/LayerID.dart';
import 'package:cv_mec/models/J2735/LayerType.dart';
import 'package:cv_mec/models/J2735/MinuteOfTheYear.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/MsgCount.dart';
import 'package:cv_mec/models/J2735/RestrictionClassList.dart';
import 'package:cv_mec/models/J2735/RoadSegmentList.dart';

class MapData {
  MinuteOfTheYear? timeStamp;

  late MsgCount msgIssueRevision;
  LayerType? layerType;
  LayerID? layerID;
  IntersectionGeometryList? intersections;
  RoadSegmentList? roadSegments;
  DataParameters? dataParameters;
  RestrictionClassList? restrictionList;

  MapData.fromC(C.MapData c_map) {
    if (c_map.timeStamp.address != 0) {
      timeStamp = MinuteOfTheYear(c_map.timeStamp.value);
    }

    msgIssueRevision = MsgCount(c_map.msgIssueRevision);

    if (c_map.layerType.address != 0) {
      layerType = LayerType.values[c_map.layerID.value];
    }

    if (c_map.layerID.address != 0) {
      layerID = LayerID(c_map.layerID.value);
    }

    intersections = IntersectionGeometryList.fromC(c_map.intersections.ref);

    if (c_map.roadSegments.address != 0) {
      roadSegments = RoadSegmentList.fromC(c_map.roadSegments.ref);
    }

    if (c_map.dataParameters.address != 0) {
      dataParameters = DataParameters.fromC(c_map.dataParameters.ref);
    }

    if (c_map.restrictionList.address != 0) {
      restrictionList = RestrictionClassList.fromC(c_map.restrictionList.ref);
    }
  }
}
