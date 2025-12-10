import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/choice/choice_toll_type_charge.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/lane_charges_table.dart';

class PerLaneChargesTable extends Choice_TollTypeCharge{
  late List<LaneChargesTable> perLaneChargesTable;
  PerLaneChargesTable.fromC(C.TollChargesTable__tollTypeCharge__perLaneCharges perLaneCharges): super() {
    perLaneChargesTable = [];
    for (int i = 0; i < perLaneCharges.list.count; i++) {
      perLaneChargesTable.add(LaneChargesTable.fromC(perLaneCharges.list.array[i].ref));
    }
  }

  LaneChargesTable getLaneChargesTableFromLaneId(int laneId) {
    for (var laneCharge in perLaneChargesTable) {
      if (laneCharge.laneId.laneID == laneId) {
        return laneCharge;
      }
    }
    throw Exception('No charges found for lane ID: $laneId');
  }
}