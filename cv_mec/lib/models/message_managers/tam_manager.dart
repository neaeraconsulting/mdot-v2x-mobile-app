import 'dart:async';

import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:cv_mec/models/geometry_direction.dart';
import 'package:cv_mec/models/mappable_tam.dart';
import 'package:cv_mec/models/message_builders/tum_message_builder.dart';
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TamManager {
  Map<int, MappableTam> storedTams = <int, MappableTam>{};
  Map<int, DateTime> tamTimestamps = <int, DateTime>{};
  bool inTamZone = false;

  static const Duration tamExpiryDuration = Duration(seconds: 30);
  static const Duration cleanupInterval = Duration(seconds: 10);
  final GeometryService geometryService = Get.find<GeometryService>();
  MappableTam? currentTam;
  Timer? _cleanupTimer;
  final double margin = 0.00001;

  TamManager() {
    _startPeriodicCleanup();
  }

  List<MappableTam> getActiveTamGeometry() {
    List<MappableTam> activeTams = [];
    for (int key in storedTams.keys) {
      MappableTam tam = storedTams[key]!;
      activeTams.add(tam);
    }
    return activeTams;
  }

  void addOrUpdate(TollAdvertisementMessage tam) {
    if (tam.tollAdvInfo == null) return;
    storedTams[tam.tollAdvInfo!.tollChargerInfo.tollPointId.tollPointID] = MappableTam.fromTam(tam);
    tamTimestamps[tam.tollAdvInfo!.tollChargerInfo.tollPointId.tollPointID] = DateTime.now();
  }

  void addOrUpdateFromString(String tamHex) {
    ASNService asnService = Get.find<ASNService>();
    TollAdvertisementMessage tam = asnService.decodeTam(tamHex);
    addOrUpdate(tam);
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (timer) {
      _cleanupExpiredTams();
    });
  }

  void _cleanupExpiredTams() {
    DateTime now = DateTime.now();
    List<int> keysToRemove = [];

    storedTams.forEach((key, tam) {
      DateTime? timestamp = tamTimestamps[key];
      if (timestamp != null && now.difference(timestamp) > tamExpiryDuration) {
        keysToRemove.add(key);
      }
    });

    for (int key in keysToRemove) {
      storedTams.remove(key);
      tamTimestamps.remove(key);
    }
  }

  (MappableTam?, ZoneType?) checkIfInZone(Position? currentPosition) { 
    bool isInTam = false; 
    bool isInApproach = false;
    for (MappableTam mappableTam in storedTams.values) {
      //Check if current position is within any TAM zone
      for (GeometryDirection geometryDirection in mappableTam.laneTollZoneGeometries) {
        Geometry border = geometryDirection.geometry;
        if (currentPosition == null) continue;
        isInTam = geometryService.isPointInPolygonWithMargin(border, currentPosition.longitude, currentPosition.latitude, margin);
        if (isInTam) {
          bool correctDirection = geometryDirection.isInPathDirection(currentPosition.longitude, currentPosition.latitude, currentPosition.heading);
          if (!correctDirection) {
            continue;
          }
          currentTam = mappableTam;
          break;
        }
      }
      if (isInTam && currentTam != null) {
        break;
      }

      //Check if current position is within any Approach zone
      for (GeometryDirection geometryDirection in mappableTam.laneApproachGeometries) {
        Geometry border = geometryDirection.geometry;
        if (currentPosition == null) continue;
        isInApproach = geometryService.isPointInPolygonWithMargin(border, currentPosition.longitude, currentPosition.latitude, margin);
        if (isInApproach) {
          bool correctDirection = geometryDirection.isInPathDirection(currentPosition.longitude, currentPosition.latitude, currentPosition.heading);
          if (!correctDirection) {
            continue;
          }
          currentTam = mappableTam;
          break;
        }
      }
      if (isInApproach && currentTam != null) {
        break;
      }
    }

    //Check if entering, exiting, or in the middle of the toll zone
    if (isInTam && currentTam != null) {
      if (!inTamZone) {
        inTamZone = true;
        return (null, null);
      }
    } else if (!isInApproach) {
      if (isInTam) {
        return (null, null);
      } else {
        inTamZone = false;
        if (currentTam != null) {
          //On exiting Toll zone
          MappableTam tempTam = currentTam!;
          currentTam = null;
          return (tempTam, ZoneType.TOLL); 
        }
      }
    }

    //Check if entering, exiting, or in the middle of the approach zone
    if (isInApproach && currentTam != null) {
      if (!inTamZone) {
        //On entering Approach zone
        inTamZone = true;
        MappableTam tempTam = currentTam!;
        currentTam = null;
        return (tempTam, ZoneType.APPROACH); 
      }
    } else if (!isInTam) {
      if (isInApproach) {
        return (null, null);
      } else {
        inTamZone = false;
        if (currentTam != null) {
          //On exiting Approach zone
          return (null, null);
        }
      }
    }
    return (null, null);
  }
}

enum ZoneType {
  TOLL,
  APPROACH
}