import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/vehicle_length.dart';
import 'package:cv_mec/models/j2735/vehicle_width.dart';

class VehicleSize {
  late VehicleWidth width;
  late VehicleLength length;

  VehicleSize.fromC(C.VehicleSize vehicleSize) {
    width = VehicleWidth(vehicleSize.width);
    length = VehicleLength(vehicleSize.length);
  }
}
