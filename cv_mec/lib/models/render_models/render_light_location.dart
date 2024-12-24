import 'package:latlong2/latlong.dart';

class RenderLightLocation {
  late LatLng
      coordinate; // stores the pre-computed coordinates for the light to be drawn at
  late Set<int>
      signalGroups; // stores the signal group this connection should use

  RenderLightLocation(this.coordinate, this.signalGroups);
}
