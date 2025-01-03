import 'package:cv_mec/models/j2735/j2735.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

class IntersectionState {
  DescriptiveName? name;
  late IntersectionReferenceID id;
  late MsgCount revision;
  late IntersectionStatusObject status;
  MinuteOfTheYear? moy;
  DSecond? timeStamp;
  EnabledLaneList? enabledLanes;
  late MovementList states;
  ManeuverAssistList? maneuverAssistList;

  IntersectionState.fromC(C.IntersectionState c_intersectionState) {
    if (c_intersectionState.name.address != 0) {
      name = DescriptiveName.fromOctetString(c_intersectionState.name.ref);
    }

    id = IntersectionReferenceID.fromC(c_intersectionState.id);

    revision = MsgCount(c_intersectionState.revision);

    status = IntersectionStatusObject.fromBitString(c_intersectionState.status);

    if (c_intersectionState.moy.address != 0) {
      moy = MinuteOfTheYear(c_intersectionState.moy.value);
    }

    if (c_intersectionState.timeStamp.address != 0) {
      timeStamp = DSecond(c_intersectionState.timeStamp.value);
    }

    if (c_intersectionState.enabledLanes.address != 0) {
      enabledLanes =
          EnabledLaneList.fromC(c_intersectionState.enabledLanes.ref);
    }

    states = MovementList.fromC(c_intersectionState.states);

    if (c_intersectionState.maneuverAssistList.address != 0) {
      maneuverAssistList =
          ManeuverAssistList.fromC(c_intersectionState.maneuverAssistList.ref);
    }
  }

  DateTime getUtcTime() {
    int year = DateTime.now().year;

    DateTime time = DateTime.utc(year, 1, 1);

    if (moy != null) {
      time = time.add(Duration(minutes: moy!.minuteOfTheYear));
    }

    if (timeStamp != null) {
      time = time.add(Duration(milliseconds: timeStamp!.dSecond));
    }

    return time;
  }
}
