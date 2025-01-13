import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/transmission_state.dart';
import 'package:cv_mec/models/j2735/velocity.dart';

class TransmissionAndSpeed {
  late TransmissionState transmission;
  late Velocity speed;

  TransmissionAndSpeed.fromC(C.TransmissionAndSpeed c_transmissionAndSpeed) {
    transmission = TransmissionState.values[c_transmissionAndSpeed.transmisson];
    speed = Velocity(c_transmissionAndSpeed.speed);
  }
}
