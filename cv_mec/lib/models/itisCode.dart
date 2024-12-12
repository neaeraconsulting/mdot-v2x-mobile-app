import 'package:flutter/material.dart';

class ItisCode {
  late int itis;
  late String description;
  late ImageProvider? image;
  late ITIS_CODE_STATUS status;

  ItisCode(int itis, String description){
    this.itis = itis;
    this.description = description;
    this.status = ITIS_CODE_STATUS.VALID;
    this.image = null;
  }
  ItisCode.withImage(int itis, String description, ImageProvider image){
    this.itis = itis;
    this.description = description;
    this.image = image;
    this.status = ITIS_CODE_STATUS.VALID;
  }

  ItisCode.error(String error){
    this.itis = -1;
    this.description = error;
    this.image = null;
    this.status = ITIS_CODE_STATUS.ERROR;
  }

  ItisCode.unknown(int itis){
    this.itis = -1;
    this.description = "Received TIM Message with ITIS: $itis";
    this.image = null;
    this.status = ITIS_CODE_STATUS.UNKNOWN;
  }
}

enum ITIS_CODE_STATUS {
  UNKNOWN,
  VALID,
  ERROR
}