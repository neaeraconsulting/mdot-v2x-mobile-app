import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_Item.dart';
import 'package:cv_mec/models/J2735/Choice_Content.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/ITIScodes.dart';
import 'package:cv_mec/models/J2735/ITIStext.dart';


class WorkZone extends Choice_Content{

  late List<Choice_Item> item;

  WorkZone.fromC(C.WorkZone workZone){
    item = [];
    for(int i=0; i < workZone.list.count; i++){
      if(workZone.list.array[i].ref.item.present == 1){
        item.add(ITIScodes(workZone.list.array[i].ref.item.choice.itis));
      }else if(workZone.list.array[i].ref.item.present == 2){
        item.add(ITIStext.fromOctetString(workZone.list.array[i].ref.item.choice.text));
      }
    }
  }
}