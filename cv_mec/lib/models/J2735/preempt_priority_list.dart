import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/signal_control_zone.dart';

class PreemptPriorityList {
  late List<SignalControlZone> preemptPriorityList;

  PreemptPriorityList.fromC(C.PreemptPriorityList c_preemptPriorityList) {
    preemptPriorityList = [];
  }
}
