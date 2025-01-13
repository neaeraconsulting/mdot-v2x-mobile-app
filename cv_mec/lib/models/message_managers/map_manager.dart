import 'package:cv_mec/models/j2735/connection.dart';
import 'package:cv_mec/models/j2735/connects_to_list.dart';
import 'package:cv_mec/models/j2735/generic_lane.dart';
import 'package:cv_mec/models/j2735/intersection_geometry.dart';
import 'package:cv_mec/models/j2735/intersection_reference_id.dart';
import 'package:cv_mec/models/j2735/map_data.dart';
import 'package:cv_mec/models/j2735/signal_group_id.dart';
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

  List<int> getActiveLaneIds(GeoMap map, double longitude, double latitude) {
    List<int> activeLanes = [];
    if (_geometryService.isPointInPolygon(
        map.mapBoundingBox, longitude, latitude)) {
      for (int laneId in map.laneBoundaries.keys) {
        Geometry lane = map.laneBoundaries[laneId]!;
        if (_geometryService.isPointInPolygon(lane, longitude, latitude)) {
          activeLanes.add(laneId);
        }
      }
    }
    return activeLanes;
  }

  List<int> getLaneSignalGroups(GeoMap map, int laneId) {
    List<int> signalGroups = [];
    for (GenericLane lane in map.intersectionGeometry.laneSet.laneList) {
      if (lane.laneID == laneId) {
        ConnectsToList? connections = lane.connectsTo;
        if (connections != null) {
          for (Connection connection in connections.connectsTo) {
            SignalGroupID? group = connection.signalGroup;
            if (group != null) {
              signalGroups.add(group.signalGroupID);
            }
          }
        }
      }
    }
    return signalGroups;
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
