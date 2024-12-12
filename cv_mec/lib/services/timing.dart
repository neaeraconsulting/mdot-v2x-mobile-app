import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:ntp/ntp.dart';
import 'package:flutter_kronos/flutter_kronos.dart';

class Timing extends GetxController {
  Rx<DateTime> geoTime = DateTime.now().toUtc().obs;
  Rx<DateTime> ntpTime = DateTime.now().toUtc().obs;
  Rx<DateTime> kronosTime = DateTime.now().toUtc().obs;
  Rx<DateTime> systemTime = DateTime.now().toUtc().obs;
  Rx<Duration> ntpOffset = Duration.zero.obs;
  Rx<Duration> geoOffset = Duration.zero.obs;

  Timer? _systemTimer;
  Timer? _ntpTimer;
  late LocationService _locationService;
  StreamSubscription<Position>? _positionStream;

  Timing() {
    _locationService = Get.find<LocationService>();
  }

  void getPermission() async {
    await Geolocator.requestPermission();
  }

  bool systemTimeUpdatesActive() {
    return _systemTimer?.isActive ?? false;
  }

  bool ntpUpdatesActive() {
    return _ntpTimer?.isActive ?? false;
  }

  void iterateAllTimestamps() {
    DateTime currTime = DateTime.now();
    _updateSystemTime(currTime);
    _updateNtpTime(currTime);
    _updateGeoTime(currTime);
    _updateKronosTime(currTime);
  }

  void _setNtpTimeOffset(DateTime currNtpTime, {bool update = false}) {
    DateTime currTime = (DateTime.now()).toUtc();
    ntpOffset.value = currNtpTime.toUtc().difference(currTime);
    // if currNtpTime behind, ntpOffset is negative
    if (update) {
      _updateNtpTime(currNtpTime);
    }
  }

  void _setGeospatialTimeOffset(DateTime currGeoTime, {bool update = false}) {
    DateTime currTime = (DateTime.now()).toUtc();
    geoOffset.value = currGeoTime.toUtc().difference(currTime);
    if (update) {
      _updateGeoTime(currGeoTime);
    }
  }

  void _updateSystemTime(DateTime currSystemTime) {
    systemTime.value = currSystemTime.toUtc();
  }

  void _updateNtpTime(DateTime currNtpTime) {
    ntpTime.value = currNtpTime.toUtc().add(ntpOffset.value);
  }

  void _updateGeoTime(DateTime currGeoTime) {
    geoTime.value = currGeoTime.toUtc().add(geoOffset.value);
  }

  DateTime getGeoTime() {
    return DateTime.now().toUtc().add(geoOffset.value);
  }

  void _updateKronosTime(DateTime currTime) async {
    final result = await Future.wait([
      FlutterKronos.getCurrentTimeMs,
      FlutterKronos.getCurrentNtpTimeMs,
    ]);
    kronosTime.value = DateTime.fromMillisecondsSinceEpoch(result[0]!).toUtc();
  }

  DateTime getKronosTime() {
    _updateKronosTime(DateTime.now());
    return kronosTime.value;
  }

  void startLocationUpdates() {
    _positionStream?.cancel();
    _positionStream =
        _locationService.locationStream.listen((Position position) {
      _setGeospatialTimeOffset(position.timestamp, update: true);
    });
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
  }

  Future<void> handleNtpUpdate(Timer _) async {
    _setNtpTimeOffset(await NTP.now());
  }

  void startNtpTimeUpdates() {
    // cancel timer if it is already running. This prevents multiple timers from running at the same time.
    if (ntpUpdatesActive()) {
      _ntpTimer?.cancel();
    }
    _ntpTimer =
        Timer.periodic(const Duration(milliseconds: 5000), handleNtpUpdate);
  }

  void stopNtpTimeUpdates() {
    _ntpTimer?.cancel();
  }

  void handleSystemTimeUpdate(Timer _) async {
    iterateAllTimestamps();
  }

  void startSystemTimeUpdates() {
    // cancel timer if it is already running. This prevents multiple timers from running at the same time.
    if (systemTimeUpdatesActive()) {
      _systemTimer?.cancel();
    }
    _systemTimer =
        Timer.periodic(const Duration(milliseconds: 5), handleSystemTimeUpdate);
  }

  void stopSystemTimeUpdates() {
    _systemTimer?.cancel();
  }

  void startKronosTimeUpdates() async {
    FlutterKronos.sync();

    int? currentTime = await FlutterKronos.getCurrentTimeMs;
    kronosTime.value =
        DateTime.fromMillisecondsSinceEpoch(currentTime!).toUtc();
  }

  void stopKronosTimeUpdates() {}

  void startAllUpdates() {
    startLocationUpdates();
    startNtpTimeUpdates();
    startSystemTimeUpdates();
    startKronosTimeUpdates();
  }

  void stopAllUpdates() {
    stopLocationUpdates();
    stopNtpTimeUpdates();
    stopSystemTimeUpdates();
    stopKronosTimeUpdates();
  }
}
