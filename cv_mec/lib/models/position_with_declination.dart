import 'package:geolocator/geolocator.dart';

class PositionWithDeclination {
  final Position position;
  final double? declination;

  PositionWithDeclination(this.position, this.declination);

  copyWith(
    Position? position,
    double? declination,
  ) {
    return PositionWithDeclination(
      position ?? this.position,
      declination ?? this.declination,
    );
  }
}
