import 'package:asn1_plugin/j2735/2024/choice/choice_item.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_codes.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_text.dart';
import 'package:cv_mec/models/itis/itis_converter.dart';
import 'package:flutter/material.dart';

class ItisSequence {
  late ImageProvider image;
  late List<Choice_Item> associatedCodes;
  late String description;

  ItisSequence(List<Choice_Item> codes, ImageProvider imageProvider){
    associatedCodes = codes;
    image = imageProvider;
    description = ItisConverter.getItisListAsString(associatedCodes);
  }

  ItisSequence.fromText(List<String> codes, ImageProvider imageProvider){
    associatedCodes = [];
    image = imageProvider;
    for(String code in codes){
      int? parsedCode = int.tryParse(code);
      if(parsedCode != null){
        associatedCodes.add(ITIScodes(parsedCode));
      }else{
        associatedCodes.add(ITIStext(code));
      }
    }
    description = ItisConverter.getItisListAsString(associatedCodes);
  }

  ItisSequence.fromDescription(String textDescription, ImageProvider imageProvider){
    associatedCodes = [];
    description = textDescription;
    image = imageProvider;
  }
}
