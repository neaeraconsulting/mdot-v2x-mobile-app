import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ParamController extends GetxController {
  RxString clientType = ''.obs;
  RxString clientSubtype = ''.obs;
  RxString messageFormat = ''.obs;
  RxString v2xType = ''.obs;
  RxString networkType = "non-VZ".obs;
  RxBool networkTypeToggle = true.obs;
  RxBool useFakePositionToggle = false.obs;
  bool usingFakePosition = false;
  RxDouble registrationLatitude = 0.0.obs;
  RxDouble registrationLongitude = 0.0.obs;
  RxInt messageDelay = 0.obs;
  RxBool geoRelevanceOrPrivateToggle = true.obs; //false is geo, true is private
  bool geoRelevanceOrPrivate = true; //false is geo, true is private
  RxString privateDeviceID = ''.obs;

  @override
  onInit() {
    loadDefaults();
    super.onInit();
  }

  void loadDefaults() {
    clientType.value = "Vehicle";
    clientSubtype.value = "PassengerCar";
    messageFormat.value = "j2735_gr";
    v2xType.value = "BSM";
    networkType.value = "non-VZ"; //"VZ";
    useFakePositionToggle.value = false;
    usingFakePosition = false;

    // Set Default Registration Coordinates to TFHRC, load from .env file if available
    registrationLatitude.value =
        dotenv.env['REGISTRATION_LATITUDE'] != null ? double.parse(dotenv.env['REGISTRATION_LATITUDE']!) : 38.9555;
    registrationLongitude.value =
        dotenv.env['REGISTRATION_LONGITUDE'] != null ? double.parse(dotenv.env['REGISTRATION_LONGITUDE']!) : -77.1494;

    messageDelay.value = 1000;
    geoRelevanceOrPrivateToggle.value = true;
    geoRelevanceOrPrivate = true;
    privateDeviceID.value = "self";
  }

  void saveParams(
      {required String clientType,
      required String clientSubtype,
      required String messageFormat,
      required String v2xType,
      required double fakeLatitude,
      required double fakeLongitude,
      required int messageDelay,
      required String privateDeviceID}) {
    this.clientType.value = clientType;
    this.clientSubtype.value = clientSubtype;
    this.messageFormat.value = messageFormat;
    networkType.value = networkTypeToggle.value ? "VZ" : "non-VZ";
    usingFakePosition = useFakePositionToggle.value;
    this.registrationLatitude.value = fakeLatitude;
    this.registrationLongitude.value = fakeLongitude;
    this.messageDelay.value = messageDelay;
    geoRelevanceOrPrivate = geoRelevanceOrPrivateToggle.value;
    this.privateDeviceID.value = privateDeviceID;
  }
}
