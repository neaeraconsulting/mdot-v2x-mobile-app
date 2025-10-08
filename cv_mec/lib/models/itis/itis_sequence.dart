import 'package:asn1_plugin/j2735/2024/choice/choice_item.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_codes.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_text.dart';
import 'package:cv_mec/models/itis/itis_converter.dart';
import 'package:flutter/material.dart';

class ItisSequence {
  late ImageProvider image;
  late List<Choice_Item> associatedCodes;
  late String description;

  ItisSequence(this.associatedCodes, this.image){}

  ItisSequence.fromText(List<String> codes, ImageProvider image){
    associatedCodes = [];
    description = "";
    image = image;
    for(String code in codes){
      int? parsedCode = int.tryParse(code);
      if(parsedCode != null){
        associatedCodes.add(ITIScodes(parsedCode));
        if(ItisConverter.codeLookup.containsKey(parsedCode)){
          description = "$description ${ItisConverter.codeLookup[parsedCode]!}";
        }  
      }else{
        associatedCodes.add(ITIStext(code));
      }
    }
  }

  ItisSequence.fromDescription(String description, ImageProvider image){
    associatedCodes = [];
    description = description;
    image = image;
  }
}
