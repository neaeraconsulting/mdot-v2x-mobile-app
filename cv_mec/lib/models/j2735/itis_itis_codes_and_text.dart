import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_item.dart';
import 'package:cv_mec/models/j2735/choice_content.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/itis_codes.dart';
import 'package:cv_mec/models/j2735/itis_text.dart';

class ITIS_ITIScodesAndText extends Choice_Content {
  late List<Choice_Item> item;

  ITIS_ITIScodesAndText.fromC(C.ITIScodesAndText itisCodesAndText) {
    item = [];
    for (int i = 0; i < itisCodesAndText.list.count; i++) {
      if (itisCodesAndText.list.array[i].ref.item.present ==
          C.ITIScodesAndText__Member__item_PR
              .ITIScodesAndText__Member__item_PR_itis) {
        item.add(
            ITIScodes(itisCodesAndText.list.array[i].ref.item.choice.itis));
      } else if (itisCodesAndText.list.array[i].ref.item.present ==
          C.ITIScodesAndText__Member__item_PR
              .ITIScodesAndText__Member__item_PR_text) {
        item.add(ITIStext.fromOctetString(
            itisCodesAndText.list.array[i].ref.item.choice.text));
      }
    }
  }
}
