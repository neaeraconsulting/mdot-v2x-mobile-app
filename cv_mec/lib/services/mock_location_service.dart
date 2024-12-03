import 'dart:async';
import 'dart:math';

import 'package:cv_mec/models/position_copy_with.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:amp/models/position_copy_with.dart';

// This class is a Mock Location Service. It is used by the LocationService to mock location updates.
class MockLocationService {
  // Variables
  Position _mockedLocation = Position(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      floor: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      isMocked: true);
  Timer? _mockLocationTimer;
  final Random _random = Random();

  // Location Stream
  final StreamController<Position> _locationController =
      StreamController<Position>.broadcast();
  Stream<Position> get locationStream => _locationController.stream;

  void start(latitude, longitude, {Position? mockedLocation}) async {
    if (mockedLocation != null) {
      _mockedLocation = mockedLocation;
    } else {
      _mockedLocation =
          _mockedLocation.copyWith(latitude: latitude, longitude: longitude);
    }
    startMockLocationUpdates();
  }

  Future<Position?> getCurrentLocation() async {
    return locationStream.last;
  }

  bool areLocationUpdatesActive() {
    return _mockLocationTimer?.isActive ?? false;
  }

  void _handleLocationUpdate(Timer _) {
    Position newPosition = _mockedLocation.copyWith(
        timestamp:
            DateTime.now().add(Duration(milliseconds: _random.nextInt(100))));
    _locationController.add(newPosition);
  }

  // Mock Location Methods
  void startMockLocationUpdates() {
    if (areLocationUpdatesActive()) {
      _mockLocationTimer?.cancel();
    }
    _mockLocationTimer = Timer.periodic(
        const Duration(milliseconds: 5000), _handleLocationUpdate);
  }

  void stopMockLocationUpdates() {
    _mockLocationTimer?.cancel();
  }
}
