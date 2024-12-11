import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/SignalControlZone.dart';

class PreemptPriorityList{
  late List<SignalControlZone> preemptPriorityList;

  PreemptPriorityList.fromC(C.PreemptPriorityList c_preemptPriorityList){
    preemptPriorityList = [];
  } 
}