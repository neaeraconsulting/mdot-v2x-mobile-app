import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/VehicleLength.dart';
import 'package:cv_mec/models/J2735/VehicleWidth.dart';

class VehicleSize {
  late VehicleWidth width;
  late VehicleLength length;

  VehicleSize.fromC(C.VehicleSize vehicleSize){
    width = VehicleWidth(vehicleSize.width);
    length = VehicleLength(vehicleSize.length);
  }
}