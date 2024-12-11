import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:asn1_plugin/generated_bindings.dart';
import 'package:asn1_plugin/asn1.dart';
import 'package:cv_mec/models/J2735/J2735.dart' as j2735;
import 'package:cv_mec/models/MsgTypes.dart';

import 'package:get/get.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math';

import 'package:latlong2/latlong.dart';

class ASNService extends GetxController {
  late NativeBindings _bindings;


  final String bsmTemplate = "00142500000000003FFFF5A4E900EB49D20000007FFFFFFFFFFFF080FDFA1FA1007FFF8000000000";
  final String timTemplate = "001F8090701431EB7AF1627185E2EDEE8A0F775D9B0301C263D16BD9677A37DFFFF93F422AD3001EA007F96937E1CF5AD1BDFA54EADF62C17316CB99385CE1AC000000004C7A2D7B2CEF46FB271186000422C1D5AEE008397FB1606A3D428A95ADF610590FCFC581E03208917849C3E58AD5DE10C054E6F04042AF59835016A3043480BFDF229E83A714334001002009EEEBB36000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  final String testTimTemplate = "001f55201000000000016b72506082729b899c4e5971998e94b800000fd0ad4725a000407e53713389cb2e3331d29700b76000000098b2e3aafa6e26f5d98b2e332466e2672838b2e291566e2590c814141080217130b8a0";
  final String speedTimTemplate = "001f80ca701575588d442ef002fc6b1b010f775d9b0301c27160d9416752ca37fff93f42baac21c0a017f98a7c32e5c9334edd3d10356a820f2c7a32f24145a2e6300000000138b06ca0b3a965189c46000f1087033d5e9817e3a0405d7f4e15f7e8cc0a8a340485040a4b826db525c134d286a091434973fcc53e1972e499a76e9e881ab54107963d197920a2d17328000000009c58c3da59d3e13a4e230007884284923a0244bdf50e8a25aea85bd128e2c24b895d6e07a821c6c18810c2e000001900430626e22103ddd766c0600183000251a824822ff40002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e52808045321cb9c97bb27a57de5c5732d970930c24ae1071977839e3e6bd1f47b151f1b4f9be2fd7c9ad3d3f809dee0fdf6eb6e64bffc059e2c65cadf07ed0b51937c9";
  final String testTimSpeedReduced = "001f80ca702575588d442ef002fc6b1b010f775d9b0301c27160d9416752ca37fff93f42baac21c0a017f98a7c32e5c9334edd3d10346a820f2c7a32f24145a2e6300000000138b06ca0b3a965189c46000f1087033d5e9817e3a0405d7f4e15f7e8cc0a8a340485040a4b826db525c134d286a091434973fcc53e1972e499a76e9e881a354107963d197920a2d17328000000009c58c3da59d3e13a4e230007884284923a0244bdf50e8a25aea85bd128e2c24b895d6e07a821c6c18810c2e000001900430625a22103ddd766c0600183000251a91999162b0002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e52808090ceef9121f40e0b80de326440362522d60938bcb749b2f1c135a7429633aaa46f71709484567d0e5666bca6c344cf81db5716160f0af0e088a55fab74528639";
  final String testReduceSpeedAhead = "001f8116701575588d442ef011020b1c010f775d9b0b01c2715bde59674a61affff93f42baac21c0a007f98afbf96bf5bf765414f865cb91041e58f465e4828b26700000000138adef2cb3a530d49c4670001088067d4a3077388e383dc64bda2a9b6897b153ad45c707994a84c3cfcd7b41d9bad560dc5757b86b059ed00064010c189688840f775d9b180e138aefe60b39dda7ffffc9fa15d5610e05003fd057dfcb5fadfbb2a0a7c32e5c882965c9d71e5c8820f2c7a32f241459338000000009c577f3059ceed3e4e231f00084582969000387625541e0052aa0f3f2a1307d1f57b454868ebda2ab4977b4156d33ded0abe75f55456976fed02b846817b1566e42390aa22215540068010c18070c4b4442035013ddd766c0600183000251bd1b9ece010002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e5280805f6c1e7293fa8efeeb6e9cbaa990b013f400e8f0bf971373f6850c0c3387083ad2c7eb7f2ed29d923115dcefa4bf07c8752cd77d4ff362bf9b6dd03e76d3397c";
  final String testRightLaneClosedAhead = "001f8089701575588d442ef0010d5c1c010f775d9b0301c2715bcdc96740f00ffff93f42baac21c0a007f9aa5a73e8e9330eeca821ecdfcf2e44107963d197920a2c99c000000004e2b79b92ce81e0127118f000422013eeed02b3287b42158cabeaa8adacdfda054ac501302a434825f1527ec2390ab37215543e5d497c1f60e5ed00088801006067bbaecd80600183000251bf4a8a8dc50002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e52808020b4d34048341707c2963bd6f050b20364824bfc4a7487604b52767d954688f8a833c460c2308bd18552c980f5d4935fab93e3905bc2b34afc30307842cb162c";
  final String testWorkzoneTim = "001f6b701575588d442ef0f00e5c1c010f775d9b0301c2715c4911674c9eb7fff93f42baac21c0a007f91afbf96bf5bf7654107963d197920a2ce000000002715c4911674c9eb1388ce000210809938000eda72d087d1fa2603c97d1c81f2eac720e36b4bd8004008027bbaecd80600183000251bf4a985e0a0002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e528080421ffc5d12daeb410ec5cb5cf2abbe8ae729672e7e0643f00c87b59f198ebd95843ab35ade3d36ff5035f782e4695367c72863b06b81845a4be13044fb46b892";
  final String shopTestTim = "001f53201000000000007fba84c082729b899c4e5971998e94b9e0000fd0ba5413b000407e53713389cb2e3331d29700b76f00000098b2e3aafa6e26f5d98b2e332466e2672838b2e291566e2590c814141080017130";
  final String pedTim = "001f79201000000000032ac54b2080729c57ad7259d0a20c2001fffe4fd0b9501f4028007e538af5ae4b3a1441840000b77ffff00695e05a917054c1896ccb49630027d97be0f9401414bc00afe009f619fa447e17a67f01d60ac1da09585a06ef22a3334521d870ca0cbc6148104ee470f35bfdc0000112870d4440";
  final String snowTim = "0381004003807b001f78701575588d442ef0010c6b1a010f775d9b0301c271635d816742b80ffff93f42baac21c0a007f8da7bb7f74107963d197920a2c600000000271635d816742b809388de1e02110047671d088a0d65048ed6d7824143342117657e409678b5e0476353fc26c52d781393d46b09fb2a7f8000004c10f775d9b06001830002519767c5327f0002520c01ff120081010100030180c620fb90caad3b9c508208511422512865acbd396921000326e52b7883279c83010180034801010001838183748c51728ff0d88dad3ecd5a87c471e77fb53eb57db0dad64fe5c85dd5c59e5280805c022422a198a55df34d44d29a923feb3c22cf5e6326fdd010d8eedf67f1d55b7c3bad69cb4d46ea8eb928c9ccbb8445ef4084d92c65b1e3767e7943fddd343e";
  final String queueTim = "001f810f2010000000000326e0c0d480729c57405c59d05854200183824fd0b93abf4030007e538ae80b8b3a0b0a840002ee6c1c10020a8cf8885547c72aa60dc8027d85737fc63a27e14d5873f6c04fb00001004306228221040394e2bc3ae2ce841da56bee0e027e85c9dbfa018003f29c57875c59d083b4ad7c1773707000081877544b4c74da5e1cb99604fb0b19b994000080218311e1108202ca715f0bd16742da6080061e18bf42e4f17d00c001f94e2be17a2ce85b4c10000bb9b0f0c0183a76e0407953f5c33018e1140a0a1e54fd443a986740740cca52e89fcf8027d8513d896290eebf5438fa302590b838f2781ac87d96fd3ebf02590b80062b012c85416e4703590fb000c802183128110800";
  final String longQueueTim = "001f80f52010000000000323928d8480729c57e82059d0d7a01fedc1c04fd0b9337f4018007e538afd040b3a1af403fd82ee6e0e00018aaeb561b2e17475205050ac533f854678f00a1f500000200860c450442080729c5835ec59d1193aad7d83824fd0b9343f4030007e538b06bd8b3a232755af82ee6c1c10028e8199061cdbb04cb98a658009f614e17f18a3e3508305f508244fb4000080218311e1108202ca7161e2516744e15880060e08bf42e4d87d00c001f94e2c3c4a2ce89c2b10000c81b070400e28b4f5c1438f27aa05f1b409f613faeb7a5e9f4904fd08ff4e2c8982f8c413f40c44d42896b9f027d80064010c1894088400";


  final int encodeBufferSize = 1024;

  
  final String MAP_START_FLAG = "0012";
  final String SPAT_START_FLAG = "0013";
  final String TIM_START_FLAG = "001F";
  final String BSM_START_FLAG = "0014";
  final String SSM_START_FLAG = "001E";
  final String PSM_START_FLAG = "0020";
  final String SRM_START_FLAG = "001D";

  late final List<String> checkStartFlags;
  late final Map<String, MsgType> messageTypeMap;


  Random random = Random();


  ASNService() {
    _bindings = Asn1.getBindings();
    checkStartFlags = [TIM_START_FLAG, BSM_START_FLAG];
    messageTypeMap = {
      MAP_START_FLAG: MsgType.MAP,
      SPAT_START_FLAG: MsgType.SPAT,
      TIM_START_FLAG: MsgType.TIM,
      BSM_START_FLAG: MsgType.BSM,
      SSM_START_FLAG: MsgType.SSM,
      PSM_START_FLAG: MsgType.PSM,
      SRM_START_FLAG: MsgType.SRM,
    };
  }

  Pointer<Pointer<Void>> getTemplateBSM(){
    return decode(bsmTemplate);
  }

  Pointer<Pointer<Void>> getTemplateTIM(){
    return decode(timTemplate);
  }

  MsgType determineHexMessageType(String hex){
    String hexUpper = hex.toUpperCase();
    int lowestIndex = -1;
    MsgType messageType = MsgType.UNKNOWN;
    for(int i=0; i< checkStartFlags.length; i++){
      int checkIndex = findValidStartFlagLocation(hexUpper, checkStartFlags[i]);
      if(checkIndex >=0 &&  (checkIndex < lowestIndex || lowestIndex == -1)){
        lowestIndex = checkIndex;
        messageType = messageTypeMap[checkStartFlags[i]] ?? MsgType.UNKNOWN;
      }
    }
    return messageType;
  }

  String? trimMessageHeaders(String hex, String startFlag){
    String hexUpper = hex.toUpperCase();
    int startFlagLocation = findValidStartFlagLocation(hexUpper, startFlag);
    if(startFlagLocation == -1){
      return null;
    }
    else{
      return hexUpper.substring(startFlagLocation);
    } 
  }

  // Returns the first valid location of a given start flag within the hex string
  int findValidStartFlagLocation(String hex, String startFlag){
    int index = hex.indexOf(startFlag);
    if(index !=0){
      index = hex.indexOf(startFlag, 10);
    }

    while(index != -1 && index %2 != 0){
      index = hex.indexOf(startFlag, index +1);
    }
    return index;
  }


  j2735.BasicSafetyMessage parseBSM(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage c_bsm = messageFrame.value.choice.BasicSafetyMessage;

    j2735.BasicSafetyMessage bsm = j2735.BasicSafetyMessage.fromC(c_bsm);

    return bsm;
  }


  j2735.TravelerInformation parseTim(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    TravelerInformation c_tim = messageFrame.value.choice.TravelerInformation;

    j2735.TravelerInformation tim = j2735.TravelerInformation.fromC(c_tim);

    return tim;
  }

  j2735.TravelerInformation decodeTim(String asn1){
    Pointer<Pointer<Void>> decoded = decode(asn1);

    j2735.TravelerInformation tim = parseTim(decoded);

    cleanupDecoded(decoded);

    return tim;

  }

  j2735.BasicSafetyMessage decodeBsm(String asn1){
    Pointer<Pointer<Void>> decoded = decode(asn1);

    j2735.BasicSafetyMessage bsm = parseBSM(decoded);

    cleanupDecoded(decoded);

    return bsm;
  }

  

  void cleanupDecoded(Pointer<Pointer<Void>> decoded){
    calloc.free(decoded.value);
    calloc.free(decoded);
  }

  

  void setBsmTime(Pointer<Pointer<Void>> message, DateTime time){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.secMark = time.millisecond + time.second*1000;
  }

  DateTime getBsmTime(Pointer<Pointer<Void>> message, DateTime time){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    int second = (bsm.coreData.secMark / 1000).toInt();
    if(second > 50 && time.second < 10){
      return DateTime(time.year, time.month, time.day, time.hour, time.minute, second, bsm.coreData.secMark % 1000).subtract(Duration(minutes: 1));
    }else{
      return DateTime(time.year, time.month, time.day, time.hour, time.minute, second, bsm.coreData.secMark % 1000);
    }
  }


  void setBsmLongLat(Pointer<Pointer<Void>> message, double longitude, double latitude){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.Long = (longitude * 1E7).toInt();
    bsm.coreData.lat = (latitude * 1E7).toInt();
  }

  LatLng getBsmLatLng(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;
    return LatLng(bsm.coreData.lat/1E7.toInt(), bsm.coreData.Long/1E7.toInt());
  }

  void incrementBsmMsgCnt(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    int msgCnt = bsm.coreData.msgCnt;
    msgCnt +=1;

    if(msgCnt > 127){
      msgCnt = 0;
    }
    bsm.coreData.msgCnt = msgCnt;
  }

  void randomizeBsmId(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    List<int> randomNumbers = List.generate(4, (_) => random.nextInt(255));
    Uint8List dataBuffer = bsm.coreData.id.buf.asTypedList(randomNumbers.length);
    bsm.coreData.id.size = 4;
    dataBuffer.setAll(0, randomNumbers);
    
  }

  String getBsmId(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    print("Vehicle ID Data Length: ${bsm.coreData.id.size}");

    final Uint8List byteList = bsm.coreData.id.buf.asTypedList(bsm.coreData.id.size);

    print("Vehicle ID Byte List: ${byteList}");

    // Convert the byte list to a String (assuming UTF-8 encoding)
    return bytesToHex(byteList);
  }

  Pointer<Pointer<Void>> decode(String hexInput) {

    Pointer<MessageFrame> structPtr = calloc<MessageFrame>();

    Pointer<Pointer<Void>> ptrToPtr = calloc<Pointer<Void>>();
    ptrToPtr.value = structPtr.cast<Void>();

    try{
      Pointer<asn_codec_ctx_s> optCodecCtxPtr = calloc<asn_codec_ctx_s>();
      optCodecCtxPtr.ref.max_stack_size = 0;

      Pointer<asn_TYPE_descriptor_s> typeDescriptorPtr =
          calloc<asn_TYPE_descriptor_s>();
      typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;
      
      Uint8List byteList = hexToBytes(hexInput);

      Pointer<Uint8> dataPtr = malloc.allocate<Uint8>(byteList.length);

      Uint8List dataBuffer = dataPtr.asTypedList(byteList.length);
      dataBuffer.setAll(0, byteList);

      Pointer<Void> bufferPtr = dataPtr.cast<Void>();

      int size = hexInput.length ~/ 2;

      asn_dec_rval_s rval = _bindings.uper_decode(optCodecCtxPtr,
          typeDescriptorPtr, ptrToPtr, bufferPtr, size, 0, 0);

      // if (rval.code != 0) {
      //   // print("Failed to Decode Message");
      // } else {
      //   // print("Decoded Successfully");
      // }

      calloc.free(optCodecCtxPtr);
      calloc.free(typeDescriptorPtr);
      calloc.free(dataPtr);
      
    }catch (e) {
      // No specified type, handles all
      print('Unknown Failure during decoding: $e');
    }

    return ptrToPtr;
  }


  String encode(Pointer<Pointer<Void>> structPtr){

    // Setup Required Parameter Pointers
    Pointer<asn_codec_ctx_s> optCodecCtxPtr = calloc<asn_codec_ctx_s>();
    optCodecCtxPtr.ref.max_stack_size = 0;

    Pointer<asn_TYPE_descriptor_s> typeDescriptorPtr = calloc<asn_TYPE_descriptor_s>();
    typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;

    Pointer<Uint8> buffer = calloc<Uint8>(encodeBufferSize);

    // Encode Data To Buffer
    asn_enc_rval_t rval = _bindings.asn_encode_to_buffer(optCodecCtxPtr, asn_transfer_syntax.ATS_UNALIGNED_BASIC_PER, typeDescriptorPtr, structPtr.value, buffer.cast<Void>(), encodeBufferSize);

    // Convert Encoded Data to Hexadecimal Bytes
    Uint8List encodedBinary = buffer.asTypedList(rval.encoded);
    String hexData = bytesToHex(encodedBinary);

    // Cleanup Pointer Allocations
    calloc.free(optCodecCtxPtr);
    calloc.free(typeDescriptorPtr);
    calloc.free(buffer);
    return hexData;
  }

  // Hex to Bytes function makes sure to properly join characters when joining. This is different from UTF8.encode() which treats each character as an ascii code.
  // For example Hex to Bytes converts F0 to 11110000
  // UTF.encode() converts F0 to 0100011000110000
  static Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw const FormatException('Invalid hexadecimal string');
    }
    final length = hex.length ~/ 2;
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      final hexByte = hex.substring(i * 2, i * 2 + 2);
      final byte = int.parse(hexByte, radix: 16);
      bytes[i] = byte;
    }
    return bytes;
  }

  // Bytes to Hex Function makes
  static String bytesToHex(List<int> bytes) {
    final StringBuffer buffer = StringBuffer();
    for (int byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString().toUpperCase(); // Convert to uppercase if needed
  }
}