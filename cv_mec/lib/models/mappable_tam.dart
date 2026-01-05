import 'dart:math';

import 'package:asn1_plugin/j2735/2024/common/computed_lane.dart';
import 'package:asn1_plugin/j2735/2024/common/node_list_xy.dart';
import 'package:asn1_plugin/j2735/2024/common/node_set_xy.dart';
import 'package:asn1_plugin/j2735/2024/common/position_3d.dart';
import 'package:asn1_plugin/j2735/2024/map_data/generic_lane.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_map.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:dart_jts/dart_jts.dart';
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
  GeometryService geometryService = Get.find<GeometryService>();


  MappableTam(
      {required this.tam,
      required this.approachPolylinePoints,
      required this.tollZonePolylinePoints,
      required this.tollZoneBorder,
      required this.markerPoints});


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
      tollZoneBorder = _generateTollBorderShape(tam.tollAdvInfo!.tollPointMap);
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

  List<LatLng> _generateTollBorderShape(TollPointMap tollPointMap) {
    List<GenericLane> tollZoneLanes = tollPointMap.tollZoneLanesMap.tollZoneLanesMap;
    double laneWidth = tollPointMap.laneWidth.laneWidth * 0.01;
    Position3D anchorPoint = tollPointMap.referencePoint;
    if (tollZoneLanes.length == 1) {
      Geometry? laneGeometry = geometryService.getGeometryFromNodeListXY(tollZoneLanes.first.nodeList, tollPointMap.referencePoint, laneWidth);
      if (laneGeometry != null) {
        return geometryService.convertGeometryToLatLngList(laneGeometry);
      }
      return [];
    }

    Geometry? topBorderPolygon = geometryService.getGeometryFromNodeListXY(tollZoneLanes.first.nodeList, anchorPoint, laneWidth);
    Geometry? bottomBorderPolygon = geometryService.getGeometryFromNodeListXY(tollZoneLanes.last.nodeList, anchorPoint, laneWidth);
    
    if (topBorderPolygon == null || bottomBorderPolygon == null) {
      return [];
    }

    List<LatLng> topBorderPoints = geometryService.convertGeometryToLatLngList(topBorderPolygon);
    List<LatLng> bottomBorderPoints = geometryService.convertGeometryToLatLngList(bottomBorderPolygon);
    
    topBorderPoints.removeAt(0);
    bottomBorderPoints.removeAt(0);

    //determine which border is outside and which is inside compared to the toll zone
    Coordinate testPointOne = geometryService.latLngToCoordinate(topBorderPoints[0], anchorPoint);
    Coordinate testPointTwo = geometryService.latLngToCoordinate(topBorderPoints[topBorderPoints.length - 1], anchorPoint);
    Coordinate testPointThree = geometryService.latLngToCoordinate(bottomBorderPoints[0], anchorPoint);
    Coordinate testPointFour = geometryService.latLngToCoordinate(bottomBorderPoints[bottomBorderPoints.length - 1], anchorPoint);

    //calculate center start point of the toll zone
    Coordinate startPointOne = geometryService.latLngToCoordinate(tollZonePolylinePoints.first.first, anchorPoint);
    Coordinate startPointTwo = geometryService.latLngToCoordinate(tollZonePolylinePoints.last.first, anchorPoint);
    Coordinate centerPoint = Coordinate(
      (startPointOne.x + startPointTwo.x) / 2,
      (startPointOne.y + startPointTwo.y) / 2,
    );    

    double distanceOne = geometryService.calculateDistanceBetweenCoordinates(testPointOne, centerPoint);
    double distanceTwo = geometryService.calculateDistanceBetweenCoordinates(testPointTwo, centerPoint);
    double distanceThree = geometryService.calculateDistanceBetweenCoordinates(testPointThree, centerPoint);
    double distanceFour = geometryService.calculateDistanceBetweenCoordinates(testPointFour, centerPoint);

    List<LatLng> outerBorderPoints = [];

    if (distanceOne > distanceTwo) {
      outerBorderPoints.addAll(topBorderPoints.sublist(0, (topBorderPoints.length ~/ 2)));
    } else {
      outerBorderPoints.addAll(topBorderPoints.sublist(topBorderPoints.length ~/ 2, topBorderPoints.length).reversed.toList());
    }

    for (int i = 0 ; i < tollZonePolylinePoints.length ; i++) {
      outerBorderPoints.add(tollZonePolylinePoints[i].first);
    }

    if (distanceThree > distanceFour) {
      outerBorderPoints.addAll(bottomBorderPoints.sublist(0, (bottomBorderPoints.length ~/ 2)).reversed.toList());
    } else {
      outerBorderPoints.addAll(bottomBorderPoints.sublist(bottomBorderPoints.length ~/ 2, bottomBorderPoints.length));
    }

    for (int i = tollZonePolylinePoints.length -1 ; i >= 0; i--) {
      outerBorderPoints.add(tollZonePolylinePoints[i].last);
    }

    return outerBorderPoints;
  }

  void _addMidPointMarker() {
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