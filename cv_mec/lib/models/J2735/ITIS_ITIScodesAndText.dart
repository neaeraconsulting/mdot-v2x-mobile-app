import 'dart:ffi';

import 'package:cv_mec/models/J2735/Choice_Item.dart';
import 'package:cv_mec/models/J2735/Choice_Content.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/J2735/ITIScodes.dart';
import 'package:cv_mec/models/J2735/ITIStext.dart';


class ITIS_ITIScodesAndText extends Choice_Content{

  late List<Choice_Item> item;

  ITIS_ITIScodesAndText.fromC(C.ITIScodesAndText itisCodesAndText){
    item = [];
    for(int i=0; i < itisCodesAndText.list.count; i++){
      if(itisCodesAndText.list.array[i].ref.item.present == 1){
        item.add(ITIScodes(itisCodesAndText.list.array[i].ref.item.choice.itis));
      }else if(itisCodesAndText.list.array[i].ref.item.present == 2){
        item.add(ITIStext.fromOctetString(itisCodesAndText.list.array[i].ref.item.choice.text));
      }
    }
  }
}