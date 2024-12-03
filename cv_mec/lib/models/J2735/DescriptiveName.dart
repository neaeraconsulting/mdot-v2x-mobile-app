import 'package:asn1_plugin/generated_bindings.dart' as C;
class DescriptiveName{
  late String descriptiveName;

  DescriptiveName.fromOctetString(C.OCTET_STRING string ){
    descriptiveName = string.toString();
  }
}