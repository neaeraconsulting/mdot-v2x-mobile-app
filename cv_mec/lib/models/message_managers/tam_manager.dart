import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:cv_mec/models/mappable_tam.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';

class TamManager {
  Map<int, MappableTam> storedTams = <int, MappableTam>{};

  List<MappableTam> getActiveTamGeometry() {
    List<MappableTam> activeTams = [];
    for (int key in storedTams.keys) {
      MappableTam tam = storedTams[key]!;
      activeTams.add(tam);
    }
    return activeTams;
  }

  void addOrUpdate(TollAdvertisementMessage tam) {
    storedTams[tam.tollAdvInfo!.tollChargerInfo.tollPointId.tollPointID] = MappableTam.fromTam(tam);
  }

  void addOrUpdateFromString(String tamHex) {
    ASNService asnService = Get.find<ASNService>();
    TollAdvertisementMessage tam = asnService.decodeTam(tamHex);
    addOrUpdate(tam);
  }
}