import 'package:latlong2/latlong.dart';

class RenderLaneConnection {
  late List<LatLng>
      coordinates; // stores the pre-computed coordinates to be drawn for the lane connection
  late int signalGroup; // stores the signal group this connection should use

  RenderLaneConnection(this.coordinates, this.signalGroup);
}
