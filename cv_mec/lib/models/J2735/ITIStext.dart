import 'package:asn1_plugin/generated_bindings.dart';
import 'package:cv_mec/models/J2735/Choice_Item.dart';

class ITIStext extends Choice_Item{
  late String itisText;

  ITIStext(this.itisText);

  ITIStext.fromOctetString(OCTET_STRING string){
    itisText = string.toString();
  }
}