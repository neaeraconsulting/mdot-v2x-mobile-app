import 'dart:math';

import 'package:asn1_plugin/j2735/2024/common/computed_lane.dart';
import 'package:asn1_plugin/j2735/2024/common/latitude.dart';
import 'package:asn1_plugin/j2735/2024/common/longitude.dart';
import 'package:asn1_plugin/j2735/2024/common/node_list_xy.dart';
import 'package:asn1_plugin/j2735/2024/common/node_set_xy.dart';
import 'package:asn1_plugin/j2735/2024/map_data/generic_lane.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_map.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';


class MappableTam {
  final TollAdvertisementMessage? tam;
  List<List<LatLng>> approachPolylinePoints = [];
  List<List<LatLng>> tollZonePolylinePoints = [];
  List<LatLng> tollZoneBorder = [];
  List<LatLng> markerPoints = [];
  List<LatLng> approachMarkerPoints = [];
  double approachMarkerRotation = 0.0;


  MappableTam(
      {required this.tam,
      required this.approachPolylinePoints,
      required this.tollZonePolylinePoints,
      required this.tollZoneBorder,
      required this.markerPoints});

  // Custom constructor using an initializer list
  MappableTam.fromTam(this.tam) {
    _initializePolylinePoints(tam!);
  }

  void _initializePolylinePoints(TollAdvertisementMessage tam) {
    GeometryService geometryService = Get.find<GeometryService>();
    if (tam.tollAdvInfo != null) {
      TollPointMap tollPointMap = tam.tollAdvInfo!.tollPointMap;
      TollZoneLanesMap tollZoneLanesMap = tollPointMap.tollZoneLanesMap;
      for (GenericLane lane in tollZoneLanesMap.tollZoneLanesMap) {
        List<LatLng> lanePoints = [];
        //List<Polygon> polygonLanePoints = [];
        NodeListXY nodeList = lane.nodeList;
        if (nodeList.nodeListXY is NodeSetXY) {
          NodeSetXY nodeSet = nodeList.nodeListXY as NodeSetXY;
          lanePoints = geometryService.getLatLngCoordinatesFromNodeSetXY(nodeSet, tollPointMap.referencePoint);
          tollZoneBorder = _generateTollBorderShape(lanePoints, tam.tollAdvInfo!.tollPointMap.laneWidth.laneWidth);
          tollZonePolylinePoints.add(lanePoints);
          if (lanePoints.isNotEmpty) {
            LatLng startMarker = lanePoints[0];
            LatLng endMarker = lanePoints[lanePoints.length - 1];
            LatLng midMarker = LatLng(
              (startMarker.latitude + endMarker.latitude) / 2,
              (startMarker.longitude + endMarker.longitude) / 2,
            );
            markerPoints.add(midMarker);
          }
        } else if (nodeList.nodeListXY is ComputedLane) {
          // Handle ComputedLane case if needed
        } 
      }
      ApproachLanesMap approachLanesMap = tollPointMap.approachLanesMap;
      for (GenericLane lane in approachLanesMap.approachLanesMap) {
        List<LatLng> lanePoints = [];
        NodeListXY nodeList = lane.nodeList;
        if (nodeList.nodeListXY is NodeSetXY) {
          NodeSetXY nodeSet = nodeList.nodeListXY as NodeSetXY;
          lanePoints = geometryService.getLatLngCoordinatesFromNodeSetXY(nodeSet, tollPointMap.referencePoint);
          approachPolylinePoints.add(lanePoints);
          int numOfArrows = 3;
          LatLng startPoint = lanePoints.first;
          LatLng endPoint = lanePoints.last;
          double deltaLat = (endPoint.latitude - startPoint.latitude) / (numOfArrows + 1);
          double deltaLon = (endPoint.longitude - startPoint.longitude) / (numOfArrows + 1);
          approachMarkerRotation = geometryService.calculateBearingBetweenLatLng(startPoint, endPoint) + 90.0;
          for (int i = 1; i <= numOfArrows; i++) {
            approachMarkerPoints.add(LatLng(
              startPoint.latitude + deltaLat * i,
              startPoint.longitude + deltaLon * i,
            ));
          }
          //markerPoints.add(lanePoints[0]);
        } else if (nodeList.nodeListXY is ComputedLane) {
          // Handle ComputedLane case if needed
        } 
      }
    }
    //_addSampleTamPolylinePoints();
  }

  List<LatLng> _generateTollBorderShape(List<LatLng> points, int laneWidth) {
    double widthInMeters = (laneWidth.toDouble()) / 10; // Should be divided by 100 but making the border bigger for testing
    double widthInDegreesLat =
        widthInMeters / 111320.0; // Approximate conversion factor for latitude
    double widthInDegreesLon = widthInMeters /
        (111320.0 *
            cos(points[0].latitude *
                (pi / 180.0))); // Approximate conversion factor for longitude
    List<List<LatLng>> borderZonePieces = <List<LatLng>>[];
    for (int i = 0; i < points.length - 1; i++) {
      double x1 = points[i].latitude;
      double y1 = points[i].longitude;
      double x2 = points[i + 1].latitude;
      double y2 = points[i + 1].longitude;
      double angle = (x1 == x2)
          ? pi / 2
          : (y1 == y2)
              ? 0.0
              : atan((y2 - y1) / (x2 - x1));
      double angle1 = angle + (pi / 2);
      double angle2 = angle - (pi / 2);
      double offsetX = widthInDegreesLat;
      double offsetY = widthInDegreesLon;
      double x3 = x1 + (offsetX / 2) * cos(angle1);
      double y3 = y1 + (offsetY / 2) * sin(angle1);
      double x4 = x1 + (offsetX / 2) * cos(angle2);
      double y4 = y1 + (offsetY / 2) * sin(angle2);
      double x5 = x3 + (x2 - x1);
      double y5 = y3 + (y2 - y1);
      double x6 = x4 + (x2 - x1);
      double y6 = y4 + (y2 - y1);
      // Polygon reportZonePolygon = Polygon(
      //   points: [
      //     LatLng(x3, y3),
      //     LatLng(x5, y5),
      //     LatLng(x6, y6),
      //     LatLng(x4, y4)
      //   ],
      //   color: Colors.blue,
      // );
      borderZonePieces.add([
        LatLng(x3, y3),
        LatLng(x5, y5),
        LatLng(x6, y6),
        LatLng(x4, y4)
      ]);
    }
    return cleanUpBorderZonePieces(borderZonePieces);
    //return borderZones;
  }

  List<LatLng> cleanUpBorderZonePieces(List<List<LatLng>> borderZonePieces) {
    //TODO finish this
    List<LatLng> cleanedUpPoints = [];
    for (var piece in borderZonePieces) {
      cleanedUpPoints.add(piece[0]);
      cleanedUpPoints.add(piece[1]);
    }
    for (var piece in borderZonePieces) {
      cleanedUpPoints.add(piece[2]);
      cleanedUpPoints.add(piece[3]);
    }
    return cleanedUpPoints;
  }
}