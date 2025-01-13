import 'dart:typed_data';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/asn1.dart';
import 'package:cv_mec/models/j2735/basic_safety_message.dart';
import 'package:cv_mec/models/j2735/map_data.dart';
import 'package:cv_mec/models/j2735/personal_safety_message.dart';
import 'package:cv_mec/models/j2735/spat.dart';
import 'package:cv_mec/models/j2735/traveler_information.dart';
import 'package:cv_mec/models/msg_types.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math';

import 'package:latlong2/latlong.dart';

class ASNService extends GetxController {
  late C.NativeBindings _bindings;

  final String bsmTemplate =
      "00142500000000003FFFF5A4E900EB49D20000007FFFFFFFFFFFF080FDFA1FA1007FFF8000000000";
  final String timTemplate =
      "001F8090701431EB7AF1627185E2EDEE8A0F775D9B0301C263D16BD9677A37DFFFF93F422AD3001EA007F96937E1CF5AD1BDFA54EADF62C17316CB99385CE1AC000000004C7A2D7B2CEF46FB271186000422C1D5AEE008397FB1606A3D428A95ADF610590FCFC581E03208917849C3E58AD5DE10C054E6F04042AF59835016A3043480BFDF229E83A714334001002009EEEBB36000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  final String psmTemplate =
      "00201A0000020000000000000035A4E9006B49D1FF0000FFFF00000000";

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
    checkStartFlags = [
      TIM_START_FLAG,
      BSM_START_FLAG,
      MAP_START_FLAG,
      SPAT_START_FLAG,
      PSM_START_FLAG
    ];
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

  Pointer<Pointer<Void>> getTemplateBSM() {
    return decode(bsmTemplate);
  }

  Pointer<Pointer<Void>> getTemplatePsm() {
    return decode(psmTemplate);
  }

  Pointer<Pointer<Void>> getTemplateTIM() {
    return decode(timTemplate);
  }

  MsgType determineHexMessageType(String hex) {
    String hexUpper = hex.toUpperCase();
    int lowestIndex = -1;
    MsgType messageType = MsgType.UNKNOWN;
    for (int i = 0; i < checkStartFlags.length; i++) {
      int checkIndex = findValidStartFlagLocation(hexUpper, checkStartFlags[i]);
      if (checkIndex >= 0 && (checkIndex < lowestIndex || lowestIndex == -1)) {
        lowestIndex = checkIndex;
        messageType = messageTypeMap[checkStartFlags[i]] ?? MsgType.UNKNOWN;
      }
    }
    return messageType;
  }

  String? trimMessageHeaders(String hex, String startFlag) {
    String hexUpper = hex.toUpperCase();
    int startFlagLocation = findValidStartFlagLocation(hexUpper, startFlag);
    if (startFlagLocation == -1) {
      return null;
    } else {
      return hexUpper.substring(startFlagLocation);
    }
  }

  // Returns the first valid location of a given start flag within the hex string
  int findValidStartFlagLocation(String hex, String startFlag) {
    int index = hex.indexOf(startFlag);
    if (index != 0) {
      index = hex.indexOf(startFlag, 10);
    }

    while (index != -1 && index % 2 != 0) {
      index = hex.indexOf(startFlag, index + 1);
    }
    return index;
  }

  BasicSafetyMessage parseBSM(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage cBsm = messageFrame.value.choice.BasicSafetyMessage;

    BasicSafetyMessage bsm = BasicSafetyMessage.fromC(cBsm);

    return bsm;
  }

  MapData parseMap(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.MapData cMap = messageFrame.value.choice.MapData;

    MapData map = MapData.fromC(cMap);

    return map;
  }

  Spat parseSpat(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.SPAT cSpat = messageFrame.value.choice.SPAT;

    Spat spat = Spat.fromC(cSpat);

    return spat;
  }

  TravelerInformation parseTim(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.TravelerInformation cTim = messageFrame.value.choice.TravelerInformation;

    TravelerInformation tim = TravelerInformation.fromC(cTim);

    return tim;
  }

  PersonalSafetyMessage parsePSM(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage cPsm =
        messageFrame.value.choice.PersonalSafetyMessage;

    PersonalSafetyMessage psm = PersonalSafetyMessage.fromC(cPsm);

    return psm;
  }

  BasicSafetyMessage decodeBsm(String asn1) {
    Pointer<Pointer<Void>> decoded = decode(asn1);

    BasicSafetyMessage bsm = parseBSM(decoded);

    cleanupDecoded(decoded);

    return bsm;
  }

  MapData decodeMap(String asn1) {
    Pointer<Pointer<Void>> decoded = decode(asn1);

    MapData map = parseMap(decoded);

    cleanupDecoded(decoded);

    return map;
  }

  Spat decodeSpat(String asn1) {
    Pointer<Pointer<Void>> decoded = decode(asn1);

    Spat spat = parseSpat(decoded);

    cleanupDecoded(decoded);

    return spat;
  }

  TravelerInformation decodeTim(String asn1) {
    Pointer<Pointer<Void>> decoded = decode(asn1);

    TravelerInformation tim = parseTim(decoded);

    cleanupDecoded(decoded);

    return tim;
  }

  PersonalSafetyMessage decodePsm(String asn1) {
    Pointer<Pointer<Void>> decoded = decode(asn1);

    PersonalSafetyMessage psm = parsePSM(decoded);

    cleanupDecoded(decoded);

    return psm;
  }

  void cleanupDecoded(Pointer<Pointer<Void>> decoded) {
    calloc.free(decoded.value);
    calloc.free(decoded);
  }

  void setBsmTime(Pointer<Pointer<Void>> message, DateTime time) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.secMark = time.millisecond + time.second * 1000;
  }

  DateTime getBsmTime(Pointer<Pointer<Void>> message, DateTime time) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    int second = bsm.coreData.secMark ~/ 1000;
    if (second > 50 && time.second < 10) {
      return DateTime(time.year, time.month, time.day, time.hour, time.minute,
              second, bsm.coreData.secMark % 1000)
          .subtract(const Duration(minutes: 1));
    } else {
      return DateTime(time.year, time.month, time.day, time.hour, time.minute,
          second, bsm.coreData.secMark % 1000);
    }
  }

  void setBsmLongLat(
      Pointer<Pointer<Void>> message, double longitude, double latitude) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    bsm.coreData.Long = (longitude * 1E7).toInt();
    bsm.coreData.lat = (latitude * 1E7).toInt();
  }

  LatLng getBsmLatLng(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;
    return LatLng(
        bsm.coreData.lat / 1E7.toInt(), bsm.coreData.Long / 1E7.toInt());
  }

  void incrementBsmMsgCnt(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    int msgCnt = bsm.coreData.msgCnt;
    msgCnt += 1;

    if (msgCnt > 127) {
      msgCnt = 0;
    }
    bsm.coreData.msgCnt = msgCnt;
  }

  void randomizeBsmId(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    List<int> randomNumbers = List.generate(4, (_) => random.nextInt(255));
    Uint8List dataBuffer =
        bsm.coreData.id.buf.asTypedList(randomNumbers.length);
    bsm.coreData.id.size = 4;
    dataBuffer.setAll(0, randomNumbers);
  }

  String getBsmId(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.BasicSafetyMessage bsm = messageFrame.value.choice.BasicSafetyMessage;

    final Uint8List byteList =
        bsm.coreData.id.buf.asTypedList(bsm.coreData.id.size);

    // Convert the byte list to a String (assuming UTF-8 encoding)
    return bytesToHex(byteList);
  }

  void setPsmTime(Pointer<Pointer<Void>> message, DateTime time) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    psm.secMark = time.millisecond + time.second * 1000;
  }

  DateTime getPsmTime(Pointer<Pointer<Void>> message, DateTime time) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    int second = psm.secMark ~/ 1000;
    if (second > 50 && time.second < 10) {
      return DateTime(time.year, time.month, time.day, time.hour, time.minute,
              second, psm.secMark % 1000)
          .subtract(const Duration(minutes: 1));
    } else {
      return DateTime(time.year, time.month, time.day, time.hour, time.minute,
          second, psm.secMark % 1000);
    }
  }

  void setPsmPosition(Pointer<Pointer<Void>> message, Position position) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    psm.position.Long = (position.longitude * 1E7).toInt();
    psm.position.lat = (position.latitude * 1E7).toInt();
    psm.heading = (position.heading * 0.0125).toInt();

    psm.accuracy.semiMajor = (min(position.accuracy, 12.7) * 0.05).toInt();
    psm.accuracy.semiMinor = (min(position.accuracy, 12.7) * 0.05).toInt();

    if (position.headingAccuracy == 0) {
      psm.accuracy.orientation = 65535;
    } else {
      psm.accuracy.orientation =
          (position.headingAccuracy * 360.0 / 65535.0).toInt();
    }
  }

  LatLng getPsmLatLng(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;
    return LatLng(
        psm.position.lat / 1E7.toInt(), psm.position.Long / 1E7.toInt());
  }

  void incrementPsmMsgCnt(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    int msgCnt = psm.msgCnt;
    msgCnt += 1;

    if (msgCnt > 127) {
      msgCnt = 0;
    }
    psm.msgCnt = msgCnt;
  }

  void randomizePsmId(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    List<int> randomNumbers = List.generate(4, (_) => random.nextInt(255));
    Uint8List dataBuffer = psm.id.buf.asTypedList(randomNumbers.length);
    psm.id.size = 4;
    dataBuffer.setAll(0, randomNumbers);
  }

  String getPsmId(Pointer<Pointer<Void>> message) {
    Pointer<C.MessageFrame> messageFrameValuePtr =
        message.value.cast<C.MessageFrame>();
    C.MessageFrame messageFrame = messageFrameValuePtr.ref;
    C.PersonalSafetyMessage psm =
        messageFrame.value.choice.PersonalSafetyMessage;

    final Uint8List byteList = psm.id.buf.asTypedList(psm.id.size);
    print("PSM: ${psm.id.buf.asTypedList(psm.id.size)}, ${psm.id.size}");

    // Convert the byte list to a String (assuming UTF-8 encoding)
    return bytesToHex(byteList);
  }

  Pointer<Pointer<Void>> decode(String hexInput) {
    Pointer<C.MessageFrame> structPtr = calloc<C.MessageFrame>();

    Pointer<Pointer<Void>> ptrToPtr = calloc<Pointer<Void>>();
    ptrToPtr.value = structPtr.cast<Void>();

    try {
      Pointer<C.asn_codec_ctx_s> optCodecCtxPtr = calloc<C.asn_codec_ctx_s>();
      optCodecCtxPtr.ref.max_stack_size = 0;

      Pointer<C.asn_TYPE_descriptor_s> typeDescriptorPtr =
          calloc<C.asn_TYPE_descriptor_s>();
      typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;

      Uint8List byteList = hexToBytes(hexInput);

      Pointer<Uint8> dataPtr = malloc.allocate<Uint8>(byteList.length);

      Uint8List dataBuffer = dataPtr.asTypedList(byteList.length);
      dataBuffer.setAll(0, byteList);

      Pointer<Void> bufferPtr = dataPtr.cast<Void>();

      int size = hexInput.length ~/ 2;

      C.asn_dec_rval_s rval = _bindings.uper_decode(
          optCodecCtxPtr, typeDescriptorPtr, ptrToPtr, bufferPtr, size, 0, 0);

      // if (rval.code != 0) {
      //   print("PSM: Failed to Decode Message");
      // } else {
      //   print("PSM: Decoded Successfully");
      // }

      calloc.free(optCodecCtxPtr);
      calloc.free(typeDescriptorPtr);
      calloc.free(dataPtr);
    } catch (e) {
      // No specified type, handles all
      print('Unknown Failure during decoding: $e');
    }

    return ptrToPtr;
  }

  String encode(Pointer<Pointer<Void>> structPtr) {
    // Setup Required Parameter Pointers
    Pointer<C.asn_codec_ctx_s> optCodecCtxPtr = calloc<C.asn_codec_ctx_s>();
    optCodecCtxPtr.ref.max_stack_size = 0;

    Pointer<C.asn_TYPE_descriptor_s> typeDescriptorPtr =
        calloc<C.asn_TYPE_descriptor_s>();
    typeDescriptorPtr.ref = _bindings.asn_DEF_MessageFrame;

    Pointer<Uint8> buffer = calloc<Uint8>(encodeBufferSize);

    // Encode Data To Buffer
    C.asn_enc_rval_t rval = _bindings.asn_encode_to_buffer(
        optCodecCtxPtr,
        C.asn_transfer_syntax.ATS_UNALIGNED_BASIC_PER,
        typeDescriptorPtr,
        structPtr.value,
        buffer.cast<Void>(),
        encodeBufferSize);

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
