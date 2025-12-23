import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:cv_mec/models/mappable_tam.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TamManager {
  Map<int, MappableTam> storedTams = <int, MappableTam>{};
  bool inTamZone = false;

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
  }

  void addOrUpdateFromString(String tamHex) {
    ASNService asnService = Get.find<ASNService>();
    TollAdvertisementMessage tam = asnService.decodeTam(tamHex);
    addOrUpdate(tam);
  }

  bool checkPositionInTam(List<LatLng> tamBorder, Position? position) {
    if (position == null) return false;

    // check if position is within the polygon that is defined by tamBorder
    int i, j = tamBorder.length - 1;
    bool inside = false;
    for (i = 0; i < tamBorder.length; j = i++) {
      if (((tamBorder[i].longitude > position.longitude) != (tamBorder[j].longitude > position.longitude)) &&
          (position.latitude <
              (tamBorder[j].latitude - tamBorder[i].latitude) * (position.longitude - tamBorder[i].longitude) /
                      (tamBorder[j].longitude - tamBorder[i].longitude) +
                  tamBorder[i].latitude)) {
        inside = !inside;
      }
    }
    return inside;
  }

  MappableTam? checkIfInTam(Position? currentPosition) {
    bool isInTam = false; 
    MappableTam? currentTam;
    for (MappableTam mappableTam in storedTams.values) {
      isInTam = checkPositionInTam(mappableTam.tollZoneBorder, currentPosition);
      if (isInTam) {
        currentTam = mappableTam;
        break;
      }
    }
    if (isInTam) {
      if (!inTamZone) {
        inTamZone = true;
        return currentTam;
      } 
    } else {
      inTamZone = false;
      return null;
    }
    return null;
  }
}