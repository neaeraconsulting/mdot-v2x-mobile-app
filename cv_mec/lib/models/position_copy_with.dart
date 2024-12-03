import 'package:geolocator/geolocator.dart';

// This extension method adds Position.copyWith method to the Position class. This is super useful, as it allows us to create a new Position object with updated values without having to manually copy each value.
extension PositionCopyWith on Position {
  Position copyWith({
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? heading,
    double? speed,
    double? speedAccuracy,
    int? floor,
    double? altitudeAccuracy,
    double? headingAccuracy,
    bool? isMocked,
  }) {
    return Position(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      floor: floor ?? this.floor,
      altitudeAccuracy: altitudeAccuracy ?? this.altitudeAccuracy,
      headingAccuracy: headingAccuracy ?? this.headingAccuracy,
      isMocked: isMocked ?? this.isMocked,
    );
  }
}
