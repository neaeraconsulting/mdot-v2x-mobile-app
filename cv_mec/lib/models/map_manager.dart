import 'package:cv_mec/models/J2735/IntersectionGeometry.dart';
import 'package:cv_mec/models/J2735/IntersectionReferenceID.dart';
import 'package:cv_mec/models/J2735/MapData.dart';
import 'package:cv_mec/models/geo_map.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:dart_jts/dart_jts.dart';

class MapManager {
  Map<IntersectionReferenceID, GeoMap> storedMaps =
      <IntersectionReferenceID, GeoMap>{};
  final GeometryService _geometryService = GeometryService();

  void addOrUpdate(MapData map) {
    if (map.intersections != null) {
      for (IntersectionGeometry geo
          in map.intersections!.intersectionGeometryList) {
        if (storedMaps.containsKey(geo.id)) {
          if (map.msgIssueRevision.msgCount >
              storedMaps[geo.id]!.map.msgIssueRevision.msgCount) {
            storedMaps[geo.id] = GeoMap(map, geo);
          }
        } else {
          storedMaps[geo.id] = GeoMap(map, geo);
        }
      }
    }
  }

  void removeMapByIntersectionReference(IntersectionReferenceID mapKey) {
    if (storedMaps.containsKey(mapKey)) {
      storedMaps.remove(mapKey);
    }
  }

  void removeMap(MapData map) {
    if (map.intersections != null) {
      for (IntersectionGeometry geo
          in map.intersections!.intersectionGeometryList) {
        if (storedMaps.containsKey(geo.id)) {
          storedMaps.remove(geo.id);
        }
      }
    }
  }

  List<GeoMap> getActiveMaps(double longitude, double latitude) {
    List<GeoMap> activeMaps = [];
    for (GeoMap map in storedMaps.values) {
      // Geometry Culling for Nearby MAP messages
      // if (_geometryService.isPointInPolygon(
      // map.mapBoundingBox, longitude, latitude)) {
      activeMaps.add(map);
      // }
    }

    return activeMaps;
  }

  List<Geometry> getActiveLaneGeometries(
      GeoMap map, double longitude, double latitude) {
    List<Geometry> activeLanes = [];
    if (_geometryService.isPointInPolygon(
        map.mapBoundingBox, longitude, latitude)) {
      for (Geometry lane in map.laneBoundaries.values) {
        if (_geometryService.isPointInPolygon(lane, longitude, latitude)) {
          activeLanes.add(lane);
        }
      }
    }
    return activeLanes;
  }

  List<int> getActiveLaneID(GeoMap map, double longitude, double latitude) {
    List<int> activeLanes = [];
    if (_geometryService.isPointInPolygon(
        map.mapBoundingBox, longitude, latitude)) {
      for (int laneID in map.laneBoundaries.keys) {
        Geometry lane = map.laneBoundaries[laneID]!;
        if (_geometryService.isPointInPolygon(lane, longitude, latitude)) {
          activeLanes.add(laneID);
        }
      }
    }
    return activeLanes;
  }
}
