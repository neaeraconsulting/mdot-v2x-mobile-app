class Longitude {
  late int longitude;

  Longitude(this.longitude);

  Longitude.unknown(){
    longitude = 1800000001;
  }

  double getDecimalLongitude(){
    return this.longitude / 1E7;
  }
}