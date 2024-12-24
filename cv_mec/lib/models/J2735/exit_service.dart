import 'dart:ffi';

import 'package:cv_mec/models/j2735/choice_item.dart';
import 'package:cv_mec/models/j2735/choice_content.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/models/j2735/itis_codes.dart';
import 'package:cv_mec/models/j2735/itis_text.dart';

class ExitService extends Choice_Content {
  late List<Choice_Item> item;

  ExitService.fromC(C.ExitService workZone) {
    item = [];
    for (int i = 0; i < workZone.list.count; i++) {
      if (workZone.list.array[i].ref.item.present ==
          C.ExitService__Member__item_PR.ExitService__Member__item_PR_itis) {
        item.add(ITIScodes(workZone.list.array[i].ref.item.choice.itis));
      } else if (workZone.list.array[i].ref.item.present ==
          C.ExitService__Member__item_PR.ExitService__Member__item_PR_text) {
        item.add(ITIStext.fromOctetString(
            workZone.list.array[i].ref.item.choice.text));
      }
    }
  }
}
