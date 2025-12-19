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
        NodeListXY nodeList = lane.nodeList;
        if (nodeList.nodeListXY is NodeSetXY) {
          NodeSetXY nodeSet = nodeList.nodeListXY as NodeSetXY;
          lanePoints = geometryService.getLatLngCoordinatesFromNodeSetXY(nodeSet, tollPointMap.referencePoint);
          tollZonePolylinePoints.add(lanePoints);
          
        } else if (nodeList.nodeListXY is ComputedLane) {
          // Handle ComputedLane case if needed
        } 
      }
      tollZoneBorder = _generateTollBorderShape(tam.tollAdvInfo!.tollPointMap.laneWidth.laneWidth);
      _addMidPointMarker();
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
        } else if (nodeList.nodeListXY is ComputedLane) {
          // Handle ComputedLane case if needed
        } 
      }
    }
  }

  List<LatLng> _generateTollBorderShape(int laneWidth) {
    List<LatLng> topPoints = [];
    List<LatLng> bottomPoints = [];

    if (tollZonePolylinePoints.length == 1) {
      return _generateBorderAroundLane(tollZonePolylinePoints.first, laneWidth);
    }

    topPoints = tollZonePolylinePoints.first;
    bottomPoints = tollZonePolylinePoints.last;

    List<LatLng> topBorderPoints = _generateBorderAroundLane(topPoints, laneWidth);
    List<LatLng> bottomBorderPoints = _generateBorderAroundLane(bottomPoints, laneWidth);
    
    //determine which border is outside and which is inside compared to the toll zone
    LatLng testPointOne = topBorderPoints[0];
    LatLng testPointTwo = topBorderPoints[topBorderPoints.length - 1];
    LatLng testPointThree = bottomBorderPoints[0];
    LatLng testPointFour = bottomBorderPoints[bottomBorderPoints.length - 1];

    //calculate center start point of the toll zone
    LatLng startPointOne = tollZonePolylinePoints.first.first;
    LatLng startPointTwo = tollZonePolylinePoints.last.first;
    LatLng centerPoint = LatLng(
      (startPointOne.latitude + startPointTwo.latitude) / 2,
      (startPointOne.longitude + startPointTwo.longitude) / 2,
    );    

    double distanceOne = _calculateDistance(testPointOne, centerPoint);
    double distanceTwo = _calculateDistance(testPointTwo, centerPoint);
    double distanceThree = _calculateDistance(testPointThree, centerPoint);
    double distanceFour = _calculateDistance(testPointFour, centerPoint);

    List<LatLng> outerBorderPoints = [];

    if (distanceOne > distanceTwo) {
      outerBorderPoints.addAll(topBorderPoints.sublist(0, (topBorderPoints.length ~/ 2)));
    } else {
      outerBorderPoints.addAll(topBorderPoints.sublist(topBorderPoints.length ~/ 2, topBorderPoints.length).reversed.toList());
    }

    for (int i = 0 ; i < tollZonePolylinePoints.length ; i++) {
      outerBorderPoints.add(tollZonePolylinePoints[i].last);
    }

    if (distanceThree > distanceFour) {
      outerBorderPoints.addAll(bottomBorderPoints.sublist(0, (bottomBorderPoints.length ~/ 2)).reversed.toList());
    } else {
      outerBorderPoints.addAll(bottomBorderPoints.sublist(bottomBorderPoints.length ~/ 2, bottomBorderPoints.length));
    }

    for (int i = tollZonePolylinePoints.length -1 ; i >= 0; i--) {
      outerBorderPoints.add(tollZonePolylinePoints[i].first);
    }

    return outerBorderPoints;
  }

  double _calculateDistance(LatLng pointA, LatLng pointB) {
    double latDiff = pointA.latitude - pointB.latitude;
    double lonDiff = pointA.longitude - pointB.longitude;
    return sqrt(latDiff * latDiff + lonDiff * lonDiff);
  }

  List<LatLng> _generateBorderAroundLane(List<LatLng> points, int laneWidth) {
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
      borderZonePieces.add([
        LatLng(x3, y3),
        LatLng(x5, y5),
        LatLng(x6, y6),
        LatLng(x4, y4)
      ]);
    }
    return cleanUpBorderZonePieces(borderZonePieces);
  }

  List<LatLng> cleanUpBorderZonePieces(List<List<LatLng>> borderZonePieces) {
    List<LatLng> cleanedUpPoints = [];
    for (var piece in borderZonePieces) {
      cleanedUpPoints.add(piece[0]);
      cleanedUpPoints.add(piece[1]);
    }

    for (var piece in borderZonePieces) {
      cleanedUpPoints.add(piece[2]);
      cleanedUpPoints.add(piece[3]);
    }

    //go through the points and check for any line crossings. If the line crosses, create a new point at the intersection and remove the surrounding point
    for (int i = 0; i < cleanedUpPoints.length - 3; i++) {
      LatLng p1 = cleanedUpPoints[i];
      LatLng p2 = cleanedUpPoints[i + 1];
      LatLng p3 = cleanedUpPoints[i + 2];
      LatLng p4 = cleanedUpPoints[i + 3];

      // Check for line intersection between (p1, p2) and (p3, p4)
      double denom = (p4.longitude - p3.longitude) * (p2.latitude - p1.latitude) -
          (p4.latitude - p3.latitude) * (p2.longitude - p1.longitude);
      if (denom == 0) {
        continue; // Lines are parallel
      }

      double ua = ((p4.latitude - p3.latitude) * (p1.longitude - p3.longitude) -
              (p4.longitude - p3.longitude) * (p1.latitude - p3.latitude)) /
          denom;
      double ub = ((p2.latitude - p1.latitude) * (p1.longitude - p3.longitude) -
              (p2.longitude - p1.longitude) * (p1.latitude - p3.latitude)) /
          denom;

      if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1) {
        // Lines intersect
        double intersectionX =
            p1.latitude + ua * (p2.latitude - p1.latitude);
        double intersectionY =
            p1.longitude + ua * (p2.longitude - p1.longitude);
        LatLng intersectionPoint = LatLng(intersectionX, intersectionY);

        // Replace surrounding points with the intersection point
        cleanedUpPoints[i + 1] = intersectionPoint;
        cleanedUpPoints.removeAt(i + 2);
      }
    }

    return cleanedUpPoints;
  }

  void _addMidPointMarker() {
    //TODO: fix this
    if (tollZoneBorder.isEmpty) return;
    double totalLat = 0.0;
    double totalLon = 0.0;
    for (var point in tollZoneBorder) {
      totalLat += point.latitude;
      totalLon += point.longitude;
    }
    double midLat = totalLat / tollZoneBorder.length;
    double midLon = totalLon / tollZoneBorder.length;
    markerPoints.add(LatLng(midLat, midLon));
  }
}