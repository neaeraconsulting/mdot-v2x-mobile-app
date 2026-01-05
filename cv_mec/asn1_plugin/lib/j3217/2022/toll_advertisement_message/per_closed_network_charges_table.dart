import 'dart:ffi';

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/choice/choice_toll_type_charge.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/closed_network_charges_table.dart';

class PerClosedNetworkChargesTable extends Choice_TollTypeCharge{
  late List<ClosedNetworkChargesTable> perClosedNetworkChargesTable;
  PerClosedNetworkChargesTable.fromC(C.TollChargesTable__tollTypeCharge__closedNetworkCharges closedNetworkChargesTable): super() {
    perClosedNetworkChargesTable = [];
    for (int i = 0; i < closedNetworkChargesTable.list.count; i++) {
      perClosedNetworkChargesTable.add(ClosedNetworkChargesTable.fromC(closedNetworkChargesTable.list.array[i].ref));
    }
  }
}


