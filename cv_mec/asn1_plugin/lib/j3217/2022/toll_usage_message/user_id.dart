
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j2735/2024/common/d_date_time.dart';
import 'dart:ffi';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_id.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/vehicle_types.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamps.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/lpn.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/obe_id.dart'; 


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



