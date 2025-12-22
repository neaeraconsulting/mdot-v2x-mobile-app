
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j2735/2024/common/d_date_time.dart';
import 'dart:ffi';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_id.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/vehicle_types.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamps.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/lpn.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/obe_id.dart'; 
import 'package:ffi/ffi.dart';


class UserId {

    PersonalAccountNumber? pan;
    ContractSerialNumber? contractSerialNumber;
    Lpn? licencePlateNumber;
    ObeId? obeId;
    String? iccId;
    
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
      
      // Clean up existing allocations first
      _cleanupExistingAllocations(c_userId);
      
      // Zero-initialize the struct
      pointer.cast<Uint8>().asTypedList(sizeOf<C.UserId>()).fillRange(0, sizeOf<C.UserId>(), 0);
      
      // Handle pan (PersonalAccountNumber)
      if (pan != null) {
        final panPtr = calloc<C.OCTET_STRING>();
        panPtr.cast<Uint8>().asTypedList(sizeOf<C.OCTET_STRING>()).fillRange(0, sizeOf<C.OCTET_STRING>(), 0);
        _stringToOctetString(pan!.pan, panPtr);
        c_userId.pan = panPtr;
      } else {
        c_userId.pan = nullptr;
      }
      
      // Handle contractSerialNumber
      if (contractSerialNumber != null) {
        final contractSerialNumberPtr = calloc<Int32>();
        contractSerialNumberPtr.value = contractSerialNumber!.contractSerialNumber;
        c_userId.contractSerialNumber = contractSerialNumberPtr as Pointer<C.ContractSerialNumber_t>;
      } else {
        c_userId.contractSerialNumber = nullptr;
      }
      
      // Handle licencePlateNumber (Lpn)
      if (licencePlateNumber != null) {
        final licencePlateNumberPtr = calloc<C.Lpn>();
        licencePlateNumberPtr.cast<Uint8>().asTypedList(sizeOf<C.Lpn>()).fillRange(0, sizeOf<C.Lpn>(), 0);
        licencePlateNumber!.toC(licencePlateNumberPtr);
        c_userId.licencePlateNumber = licencePlateNumberPtr;
      } else {
        c_userId.licencePlateNumber = nullptr;
      }
      
      // Handle obeId
      if (obeId != null) {
        final obeIdPtr = calloc<C.ObeId>();
        obeIdPtr.cast<Uint8>().asTypedList(sizeOf<C.ObeId>()).fillRange(0, sizeOf<C.ObeId>(), 0);
        obeId!.toC(obeIdPtr);
        c_userId.obeId = obeIdPtr;
      } else {
        c_userId.obeId = nullptr;
      }
      
      // Handle iccId (OCTET_STRING)
      if (iccId != null) {
        final iccIdPtr = calloc<C.OCTET_STRING>();
        iccIdPtr.cast<Uint8>().asTypedList(sizeOf<C.OCTET_STRING>()).fillRange(0, sizeOf<C.OCTET_STRING>(), 0);
        _stringToOctetString(iccId!, iccIdPtr);
        c_userId.iccId = iccIdPtr;
      } else {
        c_userId.iccId = nullptr;
      }
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

void _cleanupExistingAllocations(C.UserId c_userId) {
  // Clean up pan
  if (c_userId.pan != nullptr) {
    if (c_userId.pan.ref.buf != nullptr) {
      calloc.free(c_userId.pan.ref.buf);
      c_userId.pan.ref.buf = nullptr;
      c_userId.pan.ref.size = 0;
    }
    calloc.free(c_userId.pan);
    c_userId.pan = nullptr;
  }
  
  // Clean up contractSerialNumber
  if (c_userId.contractSerialNumber != nullptr) {
    calloc.free(c_userId.contractSerialNumber);
    c_userId.contractSerialNumber = nullptr;
  }
  
  // Clean up licencePlateNumber
  if (c_userId.licencePlateNumber != nullptr) {
    calloc.free(c_userId.licencePlateNumber);
    c_userId.licencePlateNumber = nullptr;
  }
  
  // Clean up obeId
  if (c_userId.obeId != nullptr) {
    calloc.free(c_userId.obeId);
    c_userId.obeId = nullptr;
  }
  
  // Clean up iccId
  if (c_userId.iccId != nullptr) {
    if (c_userId.iccId.ref.buf != nullptr) {
      calloc.free(c_userId.iccId.ref.buf);
      c_userId.iccId.ref.buf = nullptr;
      c_userId.iccId.ref.size = 0;
    }
    calloc.free(c_userId.iccId);
    c_userId.iccId = nullptr;
  }
}
}

class PersonalAccountNumber{
  late String pan;
  PersonalAccountNumber(Pointer<C.OCTET_STRING> c_obj){
    final byteList = c_obj.ref.buf.asTypedList(c_obj.ref.size);
    pan = String.fromCharCodes(byteList);
  }
}

class ContractSerialNumber{
  late int contractSerialNumber;
  ContractSerialNumber(int value){
    contractSerialNumber = value;
  }
}



