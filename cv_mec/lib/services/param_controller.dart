import 'package:cv_mec/services/location_service.dart';
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

  void loadDefaults() async {
    clientType.value = "Vehicle";
    clientSubtype.value = "PassengerCar";
    messageFormat.value = "j2735_gr";
    v2xType.value = "BSM";
    networkType.value = "non-VZ"; //"VZ";
    useFakePositionToggle.value = false;
    usingFakePosition = false;

    // Set Default Registration Coordinates to TFHRC, load from .env file if available
    LocationService locationService = Get.find<LocationService>();
    Position? currentLocation = await locationService.getCurrentLocation();
    final fairbanksLatLng = _latLngFromEnv('REGISTRATION_FAIRBANKS_LATITUDE', 'REGISTRATION_FAIRBANKS_LONGITUDE');
    final coloradoLatLng = _latLngFromEnv('REGISTRATION_COLORADO_LATITUDE', 'REGISTRATION_COLORADO_LONGITUDE');
    final atlantaLatLng = _latLngFromEnv('REGISTRATION_ATLANTA_LATITUDE', 'REGISTRATION_ATLANTA_LONGITUDE');
    final newYorkLatLng = _latLngFromEnv('REGISTRATION_NEW_YORK_LATITUDE', 'REGISTRATION_NEW_YORK_LONGITUDE');
    List<LatLng> registrationLocations = [];
    if (fairbanksLatLng != null) {
      registrationLocations.add(fairbanksLatLng);
    }
    if (coloradoLatLng != null) {
      registrationLocations.add(coloradoLatLng);
    }
    if (atlantaLatLng != null) {
      registrationLocations.add(atlantaLatLng);
    }
    if (newYorkLatLng != null) {
      registrationLocations.add(newYorkLatLng);
    }

    LatLng registrationLocation = _findClosestRegistrationLocation(currentLocation, registrationLocations);

    registrationLatitude.value = registrationLocation.latitude;
    registrationLongitude.value = registrationLocation.longitude;

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

  LatLng? _latLngFromEnv(String latKey, String lngKey) {
    final latStr = dotenv.env[latKey];
    final lngStr = dotenv.env[lngKey];
    final lat = double.tryParse(latStr ?? '');
    final lng = double.tryParse(lngStr ?? '');
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    return null;
  }

  LatLng _findClosestRegistrationLocation(Position? currentLocation, List<LatLng> registrationLocations) {
    if (currentLocation == null || registrationLocations.isEmpty) {
      return LatLng(38.9555, -77.1494); // Default fallback
    }
    LatLng currentLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);
    return registrationLocations.reduce((a, b) => _distance(a, currentLatLng) < _distance(b, currentLatLng) ? a : b);
  }

  double _distance(LatLng a, LatLng b) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Meter, a, b);
  }
}
