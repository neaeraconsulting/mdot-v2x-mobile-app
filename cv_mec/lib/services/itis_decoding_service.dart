import 'dart:convert';
import 'package:asn1_plugin/j2735/2024/choice/choice_content.dart';
import 'package:asn1_plugin/j2735/2024/choice/choice_item.dart';
import 'package:asn1_plugin/j2735/2024/common/speed_limit.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_codes.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_itis_codes_and_text.dart';
import 'package:asn1_plugin/j2735/2024/itis/itis_text.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/exit_service.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/generic_signage.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/traveler_data_frame.dart';
import 'package:asn1_plugin/j2735/2024/traveler_information/work_zone.dart';
import 'package:cv_mec/models/itis/itis_converter.dart';
import 'package:cv_mec/models/itis/itis_sequence.dart';
import 'package:cv_mec/models/text_overlay.dart';
import 'package:cv_mec/models/tim_definition.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;

class ItisDecodingService{

  final int maxItisSmallNumber = 12799;
  final int minItisSmallNumber = 12545;
  final int minItisLargeNumber = 11531;
  final int maxItisLargeNumber = 11613;

  final Logger logger = Logger();
  final String imageDirectory = "assets/images/tims";
  final String fontDirectory = "assets/fonts";
  late final ImageProvider missing =AssetImage("$imageDirectory/missing.png");

  Map<String, ItisSequence> graphicsMap = {};
  List<TimDefinition> dynamicTims = [];
  
  ItisDecodingService(){
    loadTims();
  }

  Future<ItisSequence> getSequenceForFrame(TravelerDataFrame frame) async{
    String category;
    List<Choice_Item> items;
    if (frame.content is WorkZone) {
      category = "workZone";
      items = (frame.content as WorkZone).item;
    } else if (frame.content is ExitService) {
      category = "exitService";
      items = (frame.content as ExitService).item;
    } else if (frame.content is GenericSignage) {
      category = "genericSign";
      items = (frame.content as GenericSignage).item;
    } else if (frame.content is SpeedLimit) {
      category = "speedLimit";
      items = (frame.content as SpeedLimit).item;
    } else if (frame.content is ITIS_ITIScodesAndText) {
      category = "advisory";
      items = (frame.content as ITIS_ITIScodesAndText).item;
    } else {
      logger.e("Unable to Map category for content type ${frame.content}");
      return ItisSequence([], missing);
    }

    String key = getKeyForTimItisCodes(category, items);

    if(graphicsMap.containsKey(key)){
      return graphicsMap[key]!;
    }else{
      return await getDynamicSequence(category, items);
    }

  }

  Future<ItisSequence> getDynamicSequence(String category, List<Choice_Item> items) async {
    print("Checking TIM Definition");
    for(TimDefinition def in dynamicTims){

      if(doesTimMatchSequence(def, category, items)){
        List<String> populateValues = getValuesForSequence(def, items);
        return ItisSequence(items, await createDynamicImage(def, populateValues));
      }
    }
    logger.e("Unable to find Matching TIM definition for message $category ${ItisConverter.getItisListAsString(items)}");
    return ItisSequence(items, missing);
  }


  List<String> getValuesForSequence(TimDefinition definition, List<Choice_Item> items){
    List<String> values = [];

    String codeString = "";
    for(Choice_Item code in items){
      if(code is ITIScodes){
        codeString = "$codeString ${code.itisCode}";
      }
    }

    for(int i=0; i< definition.codes.length; i++){
      if(definition.codes[i] == "#"){
        if(items[i] is ITIScodes){
          values.add(getIntFromItis((items[i] as ITIScodes).itisCode).toString());
        }else{
          values.add((items[i] as ITIStext).itisText);
        }
      }
    }
    return values;
  }


  
  // Loads all Predefined TIM messages from tims.json into the system
  Future<Map<String, ItisSequence>> loadTims() async {
    final String jsonString = await rootBundle.loadString('assets/tims.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);

    Map<String,ItisSequence> codes = {};

    var timsList = json['tims'] as List;
    List<TimDefinition> tims = timsList.map((t) => TimDefinition.fromJson(t)).toList();
    for(TimDefinition def in tims){

      // Pre-Cache all of the static TIMs into memory to improve performance.
      if(isStringSequenceStatic(def.codes)){
        String key = getKeyForTimDefinition(def.type, def.codes);

        if(graphicsMap.containsKey(key)){
          logger.w("Key $key has already been loaded into graphics map. Duplicate entries in TIM JSON file. The first option will be used.");
        }else{
          ImageProvider image = getImage(def.graphic) ?? missing;
          graphicsMap[key] = ItisSequence.fromText(def.codes, image); 
        }
      }else{
        // Dynamic TIMs will be generated and cached as needed. Keep a short list of TIM message definitions to match.
        dynamicTims.add(def);
      }
    }
    return codes;
  }

  bool isStringSequenceStatic(List<String> sequence){
    for(String elem in sequence){
      if (elem == "#" || elem == "*" || (elem.isNotEmpty && elem[0] == '[')) {
        return false;
      }
    }
    return true;
  }

  Future<ImageProvider<Object>> createDynamicImage(TimDefinition definition, List<String> values) async{
    try{
      final ByteData assetImageByteData = await rootBundle.load('$imageDirectory/${definition.graphic}');
      Image.Image? baseSizeImage = Image.decodeImage(assetImageByteData.buffer.asUint8List());
      if (baseSizeImage != null) {
        for(int i =0; i< definition.overlays.length; i++){
          TextOverlay overlay = definition.overlays[i];
          
          Image.BitmapFont font;

          int value = int.tryParse(values[i])??-1;

          if (value >= 100) {
            font = await getFont(overlay.minorFontSize);
          }else{
            font = await getFont(overlay.majorFontSize);
          }

          Image.drawString(baseSizeImage, values[i], font: font, color: Image.ColorRgba8(0, 0, 0, 200), x:overlay.xPos, y: overlay.yPos);
        }
        return MemoryImage(Image.encodePng(baseSizeImage));
      }else{
        logger.e("Unable to Load Base Image when creating dynamic Image $imageDirectory/${definition.graphic}");
        return missing;
      }
    }on Exception catch(e){
      logger.e("Generic Exception in creating Dynamic Image $e");
      return missing;
    }
  }

  ImageProvider? getImage(String imagePath){
    try{
      ImageProvider image = AssetImage("$imageDirectory/${imagePath}");
      return image;
    } on Exception catch(e){
      logger.e("Unable to Load Image from Path $imagePath");
      return null;
    }
  }

  Future<Image.BitmapFont> getFont(int size) async {
    // Currently all fonts must be preloaded statically. Only Fonts between size 8 and 80 in increments of 4 have been loaded. 
    // Force font to be an increment of 4
    size = size - (size %4);
    
    //Force font to be between 8 and 80 inclusive
    if(size >= 80){
      size = 80;
    }else if(size <= 8){
      size = 8;
    }

    final ByteData assetFontByteData = await rootBundle.load("$fontDirectory/HighwayGothic_$size.zip");
    return Image.readFontZip(assetFontByteData.buffer.asUint8List());
  }

  String getKeyForTimDefinition(String category, List<String> itisCodes){
    String key = "${category}";
    for(String code in itisCodes){
      key = "${key}_${code}";
    }
    return key;
  }

  String getKeyForTimItisCodes(String category, List<Choice_Item> itisCodes){
    String key = "${category}_";
    for(Choice_Item code in itisCodes){
      String codeString = ItisConverter.getItisMessageAsString(code);
      key = "${key}_${codeString}";
    }
    return key;
  }

  String getCategory(Choice_Content content){
    if (content is WorkZone) {
      // Work Zone
      return "workZone";
    } else if (content is ExitService) {
      // Exit Service
      return "exitService";
    } else if (content is GenericSignage) {
      // Generic Signage
      return "genericSign";
    } else if (content is SpeedLimit) {
      // Speed Limit
      return "speedLimit";
    } else if (content is ITIS_ITIScodesAndText) {
      // Advisory
      return "advisory";
    } else {
      logger.e("Unable to Map category for content type $content");
      return "";
    }
  }

  bool doesTimMatchSequence(TimDefinition def, String category, List<Choice_Item> codes){
    print("    Checking ${def.codes}");
    if(category != def.type){
      print("        Checking Rejected on Type");
      return false;
    }

    if(def.codes.length != codes.length){
      print("        Checking Rejected on Length");
      return false;
    }

    for(int i=0; i< def.codes.length; i++){
      // Perform Numeric Comparison
      if(!doesCodeMatchSymbol(def.codes[i], codes[i])){
        print("        Checking Rejected on Codes ${def.codes[i]} ${codes[i]}");
        return false;
      }
    }


    return true;
  }

  bool doesCodeMatchSymbol(String symbol, Choice_Item item){
    if (item is ITIScodes) {
      int code = item.itisCode;
      if(symbol == '*'){
        return true;
      }else if(symbol.length > 0 && symbol[0] == '['){
        List<int> numbers = (jsonDecode(symbol) as List).map((e) => int.tryParse(e.toString()) ?? 0).toList();
        return numbers.contains(code);
      }else if(symbol == "#" && isItisNumber(code)){
        return true;
      }else{
        return symbol == code.toString();
      }
    } else if (item is ITIStext) {
      String text = item.itisText;
      return symbol == text.toString();
    }
    return false;

  }

  
  int getIntFromItis(int itis) {
    int value = itis - minItisSmallNumber + 1;
    if (value >= 0 && value <= 255) {
      return value;
    }else if(itis >= 11531 && value <= 11613){
      if(ItisConverter.codeLookup.containsKey(itis)){
        return int.tryParse(ItisConverter.codeLookup[itis]!)??0;
      }
    }
    return -1;
  }

  bool isItisNumber(int itis){
    if ((itis >= minItisSmallNumber && itis <= maxItisSmallNumber) || (itis >= minItisLargeNumber && itis < maxItisLargeNumber)) {
      return true;
    }
    return false;
  }

}

