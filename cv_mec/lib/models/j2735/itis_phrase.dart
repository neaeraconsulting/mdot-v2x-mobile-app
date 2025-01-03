import 'package:asn1_plugin/generated_bindings.dart';
import 'package:cv_mec/models/j2735/choice_item.dart';

class ITISPhrase extends Choice_Item {
  late String itisPhrase;

  ITISPhrase(this.itisPhrase);

  ITISPhrase.fromOctetString(OCTET_STRING string) {
    itisPhrase = string.toString();
  }
}
