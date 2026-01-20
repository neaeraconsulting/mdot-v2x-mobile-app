
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j2735/2024/common/d_date_time.dart';
import 'dart:ffi';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_id.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/vehicle_types.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/contract_serial_number.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamps.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/lpn.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/obe_id.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/personal_account_number.dart'; 
import 'package:ffi/ffi.dart';


class UserId {

  PersonalAccountNumber? pan;
  ContractSerialNumber? contractSerialNumber;
  Lpn? licencePlateNumber;
  ObeId? obeId;
  String? iccId;

  UserId.fromDetails(
    this.pan,
    this.contractSerialNumber,
    this.licencePlateNumber,
    this.obeId,
    this.iccId,
  );
  
  UserId.fromC(C.UserId c_obj){
    if(c_obj.pan.address != 0){
        pan = PersonalAccountNumber(c_obj.pan);
    }

    if(c_obj.contractSerialNumber.address != 0){
        contractSerialNumber = ContractSerialNumber(c_obj.contractSerialNumber.value);
    }

    if(c_obj.licencePlateNumber.address != 0){
        licencePlateNumber = Lpn.fromC(c_obj.licencePlateNumber.ref);
    }

    if(c_obj.obeId.address != 0){
        obeId = ObeId.fromC(c_obj.obeId.ref);
    }

    if(c_obj.iccId.address != 0){
        iccId = String.fromCharCodes(c_obj.iccId.ref.buf.asTypedList(c_obj.iccId.ref.size));
    }
  }

  void toC(Pointer<C.UserId> pointer) {
    final c_userId = pointer.ref;
    
    pointer.cast<Uint8>().asTypedList(sizeOf<C.UserId>()).fillRange(0, sizeOf<C.UserId>(), 0);
    
    if (pan != null) {
      final panPtr = calloc<C.OCTET_STRING>();
      panPtr.cast<Uint8>().asTypedList(sizeOf<C.OCTET_STRING>()).fillRange(0, sizeOf<C.OCTET_STRING>(), 0);
      _stringToOctetString(pan!.pan, panPtr);
      c_userId.pan = panPtr;
    } else {
      c_userId.pan = nullptr;
    }
    
    if (contractSerialNumber != null) {
      final contractSerialNumberPtr = calloc<Int32>();
      contractSerialNumberPtr.value = contractSerialNumber!.contractSerialNumber;
      c_userId.contractSerialNumber = contractSerialNumberPtr as Pointer<C.ContractSerialNumber_t>;
    } else {
      c_userId.contractSerialNumber = nullptr;
    }
    
    if (licencePlateNumber != null) {
      final licencePlateNumberPtr = calloc<C.Lpn>();
      licencePlateNumberPtr.cast<Uint8>().asTypedList(sizeOf<C.Lpn>()).fillRange(0, sizeOf<C.Lpn>(), 0);
      licencePlateNumber!.toC(licencePlateNumberPtr);
      c_userId.licencePlateNumber = licencePlateNumberPtr;
    } else {
      c_userId.licencePlateNumber = nullptr;
    }
    
    if (obeId != null) {
      final obeIdPtr = calloc<C.ObeId>();
      obeIdPtr.cast<Uint8>().asTypedList(sizeOf<C.ObeId>()).fillRange(0, sizeOf<C.ObeId>(), 0);
      obeId!.toC(obeIdPtr);
      c_userId.obeId = obeIdPtr;
    } else {
      c_userId.obeId = nullptr;
    }

    if (iccId != null) {
      final iccIdPtr = calloc<C.OCTET_STRING>();
      iccIdPtr.cast<Uint8>().asTypedList(sizeOf<C.OCTET_STRING>()).fillRange(0, sizeOf<C.OCTET_STRING>(), 0);
      _stringToOctetString(iccId!, iccIdPtr);
      c_userId.iccId = iccIdPtr;
    } else {
      c_userId.iccId = nullptr;
    }
  }

  void free(Pointer<C.UserId> pointer) {
    final c_userId = pointer.ref;

    if (c_userId.pan != nullptr) {
      calloc.free(c_userId.pan.ref.buf);
      calloc.free(c_userId.pan);
      c_userId.pan = nullptr;
    }

    if (c_userId.contractSerialNumber != nullptr) {
      calloc.free(c_userId.contractSerialNumber);
      c_userId.contractSerialNumber = nullptr;
    }

    if (c_userId.licencePlateNumber != nullptr) {
      licencePlateNumber!.free(c_userId.licencePlateNumber);
      c_userId.licencePlateNumber = nullptr;
    }

    if (c_userId.obeId != nullptr) {
      obeId!.free(c_userId.obeId);
      c_userId.obeId = nullptr;
    }

    if (c_userId.iccId != nullptr) {
      calloc.free(c_userId.iccId.ref.buf);
      calloc.free(c_userId.iccId);
      c_userId.iccId = nullptr;
    }

    calloc.free(pointer);
  }

  void _stringToOctetString(String str, Pointer<C.OCTET_STRING> octetPtr) {
    List<int> bytes = str.codeUnits;
    
    if (bytes.isNotEmpty) {
      octetPtr.ref.buf = calloc<Uint8>(bytes.length);
      octetPtr.ref.size = bytes.length;
      
      for (int i = 0; i < bytes.length; i++) {
        octetPtr.ref.buf[i] = bytes[i];
      }
    } else {
      octetPtr.ref.buf = nullptr;
      octetPtr.ref.size = 0;
    }
  }
}



