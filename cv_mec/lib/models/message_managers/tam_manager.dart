import 'package:asn1_plugin/j2735/2024/common/heading_slice.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/traveler_data_frame.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/traveler_information.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_charges_table.dart';
import 'package:cv_mec/models/geo_map.dart';
import 'package:cv_mec/models/geometry_direction.dart';
import 'package:cv_mec/models/data_frame_geometry.dart';
import 'package:cv_mec/models/itis/itis_sequence.dart';
import 'package:cv_mec/models/mappable_tam.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:cv_mec/services/itis_decoding_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TamManager {
  Map<int, TollAdvertisementMessage> storedTams = <int, TollAdvertisementMessage>{};


  List<MappableTam> getActiveTamGeometry() {
    List<MappableTam> activeTams = [];
    for (int key in storedTams.keys) {
      TollAdvertisementMessage tam = storedTams[key]!;
      activeTams.add(MappableTam.fromTam(tam));
    }
    //activeTams.add(MappableTam.sample());
    TollAdvertisementMessage sample = getSampleTam();
    
    activeTams.add(MappableTam.fromTam(sample));
    return activeTams;
  }

  TollAdvertisementMessage getSampleTam() {
    String sampleTam = "002581f14d3810957900e1cc9390344a8e3400d71b857868c4e1025aab48fee8546eb1881a08510c1002bc618d4e2d38742142ab666cfb34e3d5b126bcc9b229cc934a54a8f16cd9b32bfdefceec6c55e5bd11c14fc6212c5e9a5b89eca70b07af2c001fa891833694c9b2a6d3a11aad0b162942ab2b49beecac4e8f4bbb5ec2f7c6848944ae23f775ce8df2860a0ac1f97c7c57fb7cdec9580f0e0e4cf0cb5413f2b613e856975aa518f063d3a736c44a1426d1954e1d4a336c4d9b12bd59f12344af46bd1b3566c99d1e5588948f5dce671cd982008b468f7e6b1116420102c00159196d936bea4afcce040c8e0205326c37102d9ca0e2888fcb32a77c715182e8405bfaca00d369b20a46a849bfd96521c7e86663528f0a7d3911e259b30a4d59b069d785122ceb15ebd5510770ef1b91f0027d072c7e463981025cf937e498a66c232462362df99903433874b09644f020e8c7ce509eba92a4bfc307d9521223ec1c3f5fafd637f7d1b44c0ba44ff74bd55f392331e6bbca076fc2a2c5ab5e94fa32446e106b8739004c5bb3cfc0a80a50490a432ce6c1fe2a65261702082dd1a7e24222a0021345d14a0d01bc1434f97fadf771ff0685c95a4f7ff3a52876012c18efaaffdb2623541271fa7d39f8225e114826b00831b7114b1e4ce569e7c6cdbbe4fea509fa1895e83da7c4abd297919898";
    String sampleTamTwo = "00257a44000c00080002aa9b0400002a01f7fbf4a2d2200023404042820077359400e27f65fe51f4016d00000200000000188b7da42e65183fb988b7eda5265179fd800001000000000c45bf6fad328bce14c45c04c1d328b5ac00c00000000000003a00004005be180000000000000000000000000000000000000000";
    String sampleTamThree = "00257e44000401080052aa9900002aaa9b0400002a01f7fbf4a2d22000234020400ee6b2801c4fecbfca3e802da000004000000003116fb485cca307f73116fdb4a4ca2f3fb00000200000000188b7ed89e6517ab0188b80842a6516c6a0180000000000000740000800b7c3000000000000000000000000000000000000000000";
    String sampleTamFour = "0025809544000401080052aa9900002aaa9b0400002a01f7fbf4a2d22000234020400ee6b2801c4fecbfca3e802da000004000000003116fb485cca307f73116fdb4a4ca2f3fb02000200000000188b7ed89e6517ab0188b80842a6516c6a0001000000000622dfb5e79945e8c4622e020bd9945b0200600000000000001d00002002df0c00000000000000000000000000000000000000000";
    ASNService asnService = Get.find<ASNService>();
    return asnService.decodeTam(sampleTamThree);
  }

  void addOrUpdate(TollAdvertisementMessage tam) {
    storedTams[tam.tollAdvInfo!.tollChargerInfo.tollPointId.tollPointID] = tam;
  }
}