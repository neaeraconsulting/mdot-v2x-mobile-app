import 'dart:io';
import 'dart:typed_data';
import 'package:asn1_plugin/generated_bindings.dart';
import 'package:asn1_plugin/asn1.dart';
import 'package:cv_mec/models/J2735/J2735.dart' as j2735;

import 'package:get/get.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math';

class ASNService extends GetxController {
  late NativeBindings _bindings;


  final String bsmTemplate = "00142500000000003FFFF5A4E900EB49D20000007FFFFFFFFFFFF080FDFA1FA1007FFF8000000000";
  final String timTemplate = "001F8090701431EB7AF1627185E2EDEE8A0F775D9B0301C263D16BD9677A37DFFFF93F422AD3001EA007F96937E1CF5AD1BDFA54EADF62C17316CB99385CE1AC000000004C7A2D7B2CEF46FB271186000422C1D5AEE008397FB1606A3D428A95ADF610590FCFC581E03208917849C3E58AD5DE10C054E6F04042AF59835016A3043480BFDF229E83A714334001002009EEEBB36000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  
  Random random = Random();


  ASNService() {
    _bindings = Asn1.getBindings();
  }

  Pointer<Pointer<Void>> getTemplateBSM(){
    return decode(bsmTemplate);
  }

  void parseBSM(Pointer<Pointer<Void>> message){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;
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

  void cleanupDecoded(Pointer<Pointer<Void>> decoded){
    calloc.free(decoded.value);
    calloc.free(decoded);
  }

  void cleanupBSMTemplate(Pointer<Pointer<Void>> template){
    calloc.free(template.value);
    calloc.free(template);
  }

  void setBsmTime(Pointer<Pointer<Void>> message, DateTime time){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.secMark = time.millisecond + time.second*1000;
  }


  void setBsmLongLat(Pointer<Pointer<Void>> message, double longitude, double latitude){
    Pointer<MessageFrame> messageFrameValuePtr = message.value.cast<MessageFrame>();
    MessageFrame messageFrame = messageFrameValuePtr.ref;
    BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.Long = (longitude * 1E7).toInt();
    bsm.coreData.lat = (latitude * 1E7).toInt();
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


    // Pointer<OCTET_STRING> id = calloc<OCTET_STRING>();
    // id.ref.buf = calloc<Uint8>(4);

    List<int> randomNumbers = List.generate(4, (_) => random.nextInt(255));
    Uint8List dataBuffer = bsm.coreData.id.buf.asTypedList(randomNumbers.length);
    dataBuffer.setAll(0, randomNumbers);
    bsm.coreData.id.size = 4;
  }

  Pointer<Pointer<Void>> decode(String hexInput) {
    Pointer<asn_codec_ctx_s> optCodecCtxPtr = calloc<asn_codec_ctx_s>();
    optCodecCtxPtr.ref.max_stack_size = 0;

    Pointer<asn_TYPE_descriptor_s> typeDescriptorPtr =
        calloc<asn_TYPE_descriptor_s>();
    typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;

    Pointer<MessageFrame> structPtr = calloc<MessageFrame>();

    Pointer<Pointer<Void>> ptrToPtr = calloc<Pointer<Void>>();
    ptrToPtr.value = structPtr.cast<Void>();
    
    
    Uint8List byteList = hexToBytes(hexInput);

    Pointer<Uint8> dataPtr = malloc.allocate<Uint8>(byteList.length);

    Uint8List dataBuffer = dataPtr.asTypedList(byteList.length);
    dataBuffer.setAll(0, byteList);

    Pointer<Void> bufferPtr = dataPtr.cast<Void>();

    int size = hexInput.length ~/ 2;


    asn_dec_rval_s rval = _bindings.uper_decode(optCodecCtxPtr,
        typeDescriptorPtr, ptrToPtr, bufferPtr, size, 0, 0);

    if (rval.code != 0) {
      print("Failed to Decode Nonsense");
    } else {
      print("Decoded Successfully");
    }

    calloc.free(optCodecCtxPtr);
    calloc.free(typeDescriptorPtr);
    calloc.free(dataPtr);

    return ptrToPtr;
  }


  String encode(Pointer<Pointer<Void>> structPtr){



    Pointer<asn_codec_ctx_s> optCodecCtxPtr = calloc<asn_codec_ctx_s>();
    optCodecCtxPtr.ref.max_stack_size = 0;

    
    Pointer<asn_TYPE_descriptor_s> typeDescriptorPtr =
        calloc<asn_TYPE_descriptor_s>();
    typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;

    // asn_enc_rval_t rval = _bindings.xer_encode(typeDescriptorPtr, structPtr.value, xer_encoder_flags_e.XER_F_BASIC, _manualBindings.get_buffer_append(), xerBufferPtr);

    Pointer<Uint8> buffer = calloc<Uint8>(1024);


    Pointer<asn_per_constraints_s> constraintsPtr = calloc<asn_per_constraints_s>();
    
    
    
    // asn_enc_rval_t rval = _bindings.uper_encode_to_buffer(typeDescriptorPtr, constraintsPtr, structPtr.value, buffer.cast<Void>(), 1024);
    
    asn_enc_rval_t rval = _bindings.asn_encode_to_buffer(optCodecCtxPtr, asn_transfer_syntax.ATS_UNALIGNED_BASIC_PER, typeDescriptorPtr, structPtr.value, buffer.cast<Void>(), 1024);

    // Pointer<Uint8> 

    Uint8List encodedBinary = buffer.asTypedList(rval.encoded);


    return bytesToHex(encodedBinary);
  }

  // Hex to Bytes function makes sure to properly join characters when joining. This is different from UTF8.encode() which treats each character as an ascii code.
  // For example Hex to Bytes converts F0 to 11110000
  // UTF.encode() converts F0 to 0100011000110000
  Uint8List hexToBytes(String hex) {
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

  String bytesToHex(List<int> bytes) {
    final StringBuffer buffer = StringBuffer();
    for (int byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString().toUpperCase(); // Convert to uppercase if needed
  }
}


// String buildBsm(){
  //   Pointer<Pointer<Void>> decodedMessage = decode(bsmTemplate);

  //   Pointer<MessageFrame> messageFrameValuePtr = decodedMessage.value.cast<MessageFrame>();

  //   MessageFrame messageFrame = messageFrameValuePtr.ref;

  //   BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

  //   bsm.coreData.msgCnt = 0;

  //   Pointer<OCTET_STRING> id = calloc<OCTET_STRING>();
  //   id.ref.buf = calloc<Uint8>(4);
  //   id.ref.size = 4;

  //   bsm.coreData.id = id.ref;
  //   bsm.coreData.speed = 8191;
  //   bsm.coreData.secMark = 65535;
  //   bsm.coreData.lat = 900000001;
  //   bsm.coreData.Long = 1800000001;
  //   bsm.coreData.elev = -4096;

  //   Pointer<PositionalAccuracy> positionalAccuracy = calloc<PositionalAccuracy>();
  //   positionalAccuracy.ref.semiMajor = 255;
  //   positionalAccuracy.ref.semiMinor = 255;
  //   positionalAccuracy.ref.orientation = 65535;

  //   bsm.coreData.accuracy = positionalAccuracy.ref;

  //   bsm.coreData.transmission = TransmissionState.TransmissionState_unavailable;
  //   bsm.coreData.speed = 8191;
  //   bsm.coreData.heading = 28800;
  //   bsm.coreData.angle = 127;

  //   Pointer<AccelerationSet4Way> accelSet = calloc<AccelerationSet4Way>();

  //   accelSet.ref.Long = 2001;
  //   accelSet.ref.lat = 2001;
  //   accelSet.ref.vert = -127;
  //   accelSet.ref.yaw = 0;

  //   bsm.coreData.accelSet = accelSet.ref;


  //   Pointer<VehicleSize> vehicleSize = calloc<VehicleSize>();

  //   vehicleSize.ref.width = 0;
  //   vehicleSize.ref.length = 0;


  //   bsm.coreData.size = vehicleSize.ref;

  //   String encodedData = encode(decodedMessage);

  //   calloc.free(id.ref.buf);
  //   calloc.free(id);
  //   calloc.free(positionalAccuracy);
  //   calloc.free(accelSet);
  //   calloc.free(vehicleSize);
    

  //   return encodedData;
  // }