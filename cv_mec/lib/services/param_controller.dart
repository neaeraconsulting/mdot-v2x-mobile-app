import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ParamController extends GetxController {
  RxString clientType = ''.obs;
  RxString clientSubtype = ''.obs;
  RxString messageFormat = ''.obs;
  RxString v2xType = ''.obs;
  RxString networkType = "non-VZ".obs;
  RxBool networkTypeToggle = true.obs;
  RxBool useFakePositionToggle = false.obs;
  bool usingFakePosition = false;

  Rx<bool> manualRegistrationMode = false.obs;
  RxDouble registrationLatitude = 0.0.obs;
  RxDouble registrationLongitude = 0.0.obs;

  RxInt messageDelay = 0.obs;
  RxBool geoRelevanceOrPrivateToggle = true.obs; //false is geo, true is private
  bool geoRelevanceOrPrivate = true; //false is geo, true is private
  RxString privateDeviceID = ''.obs;

  late double manualLatitude;
  late double manualLongitude;

  final SecureStorage secureStorage = SecureStorage();

  @override
  onInit() {
    loadDefaults();
    super.onInit();
  }

  void loadDefaults() async {
    clientType.value = "Vehicle";
    clientSubtype.value = "PassengerCar";
    messageFormat.value = "j2735_gr";
    v2xType.value = "BSM";
    networkType.value = "non-VZ"; //"VZ";
    useFakePositionToggle.value = false;
    usingFakePosition = false;

    // Set Default Registration Coordinates to TFHRC, load from .env file if available
    manualRegistrationMode.value = await secureStorage.getManualRegistrationMode();
    manualLatitude = await secureStorage.getRegistrationLatitude();
    manualLongitude = await secureStorage.getRegistrationLongitude();
    if (manualLatitude == 0.0) {
      manualLatitude = double.parse(dotenv.env['REGISTRATION_LATITUDE']!);
    }
    if (manualLongitude == 0.0) {
      manualLongitude = double.parse(dotenv.env['REGISTRATION_LONGITUDE']!);
    }
    if (manualRegistrationMode.value) {
      registrationLatitude.value = manualLatitude;
      registrationLongitude.value = manualLongitude;
    } else {
      LocationService locationService = Get.find<LocationService>();
      Position? currentLocation = locationService.latestPosition;
      registrationLatitude.value = currentLocation?.latitude ?? manualLatitude;
      registrationLongitude.value = currentLocation?.longitude ?? manualLongitude;
    }

    messageDelay.value = 1000;
    geoRelevanceOrPrivateToggle.value = true;
    geoRelevanceOrPrivate = true;
    privateDeviceID.value = "self";
  }

  Future<void> switchManualRegistrationMode() async{
    manualRegistrationMode.value = !manualRegistrationMode.value;
    if (manualRegistrationMode.value) {
      registrationLatitude.value = manualLatitude;
      registrationLongitude.value = manualLongitude;
    } else {
      LocationService locationService = Get.find<LocationService>();
      Position? currentLocation = locationService.latestPosition;
      registrationLatitude.value = currentLocation?.latitude ?? manualLatitude;
      registrationLongitude.value = currentLocation?.longitude ?? manualLongitude;
    }
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
        print("Saving Params: $clientType, $clientSubtype, $messageFormat, $v2xType, $fakeLatitude, $fakeLongitude, $messageDelay, $privateDeviceID");
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
