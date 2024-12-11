import 'package:flutter/material.dart';

class ItisCode {
  late int itis;
  late String description;
  ImageProvider? image;
  late ITIS_CODE_STATUS status;

  String? name;

  ItisCode(int itis, String description) {
    this.itis = itis;
    this.description = description;
    status = ITIS_CODE_STATUS.VALID;
    image = null;
  }

  ItisCode.withImage(int itis, String description, ImageProvider image) {
    this.itis = itis;
    this.description = description;
    this.image = image;
    status = ITIS_CODE_STATUS.VALID;
  }

  ItisCode.error(String error) {
    itis = -1;
    description = error;
    image = null;
    status = ITIS_CODE_STATUS.ERROR;
  }

  ItisCode.unknown(int itis) {
    this.itis = -1;
    description = "Received TIM Message with ITIS: $itis";
    image = null;
    status = ITIS_CODE_STATUS.UNKNOWN;
  }
}

enum ITIS_CODE_STATUS { UNKNOWN, VALID, ERROR }
