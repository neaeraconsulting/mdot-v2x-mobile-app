import 'dart:convert';

import 'package:cv_mec/models/itis/itis_sequence.dart';
import 'package:cv_mec/models/tim_definition.dart';
import 'package:flutter/services.dart';

class ItisDecodingService{

  final int maxItisSmallNumber = 12799;
  final int minItisSmallNumber = 12545;
  
  ItisDecodingService(){

  }

  Future<Map<String, ItisSequence>> loadTims() async {
    final String jsonString = await rootBundle.loadString('assets/tims.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);

    Map<String,ItisSequence> codes = {};

    var timsList = json['tims'] as List;
    List<TimDefinition> tims = timsList.map((t) => TimDefinition.fromJson(t)).toList();
    for(TimDefinition def in tims){
      

      if(isStaticSequence(def.codes)){
        // Load Code into Dictionary
        String key = getKeyForTim(def.type, def.codes);
        codes[key] = ItisCode.withImage(
          blowingSnow, "Rain", [ITIScodes(blowingSnow)], AssetImage("$imageDirectory/$blowingSnow.png"))

      }else{
        // Code needs to be procedurally generated

      }
    }




    
    return codes;
  }


  String getKeyForTim(String category, List<int> itisCodes){
    String key = "${category}_";
    for(int code in itisCodes){
      // convert all integer values to -1, otherwise retain itis code
      int value = isItisNumber(code) ? -1 : code;

      key = "${key}_${code}";

    }
    return key;
  }

  
  int getIntFromItis(int itis) {
    int value = itis - minItisSmallNumber + 1;
    if (value >= 0 && value <= 255) {
      return value;
    }
    return -1;
  }

  bool isItisNumber(int itis){
    int value = itis - minItisSmallNumber + 1;
    if (value >= 0 && value <= 255) {
      return true;
    }
    return false;
  }
  
  bool isStaticSequence(List<int> codes){
    for(int code in codes){
      if(isItisNumber(code)){
        return false;
      }
    }
    return true;
  }

}

