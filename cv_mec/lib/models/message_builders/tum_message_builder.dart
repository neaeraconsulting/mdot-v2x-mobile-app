import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:asn1_plugin/j2735/2024/common/d_date_time.dart';
import 'package:asn1_plugin/j2735/2024/common/latitude.dart';
import 'package:asn1_plugin/j2735/2024/common/longitude.dart';
import 'package:asn1_plugin/j2735/2024/common/msg_count.dart';
import 'package:asn1_plugin/j2735/2024/common/node_list_xy.dart';
import 'package:asn1_plugin/j2735/2024/common/node_set_xy.dart';
import 'package:asn1_plugin/j2735/2024/common/temporary_id.dart';
import 'package:asn1_plugin/j3217/2022/payment_fee.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/axles_charges.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/axles_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/lane_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/per_closed_network_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/per_lane_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/time_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_advertisement_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_charger_info.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/toll_point_map.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/total_weight_charges.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/veh_type_charges.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/veh_type_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/vehicle_types.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/weight_charges.dart';
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/weight_charges_table.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/contract_serial_number.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/encrypted_tum_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamp.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamps.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/toll_usage_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/toll_user_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/tum_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/user_id.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_axles_and_weight_info.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_id.dart';
import 'package:cv_mec/controllers/configuration_controller.dart';
import 'package:cv_mec/models/iso_4217.dart';
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/models/vehicle.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:cv_mec/services/vehicle_mapping_service.dart';
import 'package:dart_jts/dart_jts.dart' hide Position;
import 'package:ffi/ffi.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';


class TumMessageBuilder{

  ASNService asnService = Get.find<ASNService>();
  Random random = Random();
  TumMessageBuilder();
  ConfigurationController configController = Get.find<ConfigurationController>();
  GeometryService geometryService = Get.find<GeometryService>();
  final double margin = 0.00001;
  List<LocAndTimeStamp> vehiclePathInTollZone = [];
  Timer? sendingTumTimer;

  C.TollUsageMessage buildCTum(TollUsageMessage tum) {
    final tumPtr = calloc<C.TollUsageMessage>();
    tum.toC(tumPtr);
    return tumPtr.ref;
  }

  void addLocation(Position position, DateTime kronos) {
    LocAndTimeStamp locAndTime = LocAndTimeStamp(
      latitude: Latitude((position.latitude * 1E7).toInt()),
      longitude: Longitude((position.longitude * 1E7).toInt()),
      timeStamp: DDateTime.fromDateTime(kronos),
    );
    vehiclePathInTollZone.add(locAndTime); 
  }

  TollUsageMessage getSampleTum() {
    ASNService asnService = Get.find<ASNService>();
    return asnService.decodeTum(TestData.testTum);
  }

  String encodeTum(C.TollUsageMessage cTum) {
    Pointer<Pointer<Void>> tumPtrPtr = tollUsageMessageToPtrPtr(cTum);
    int requiredBufferSize = calculateRequiredBufferSize(cTum);
    String encodedTum = asnService.encode(tumPtrPtr, encodeBufferSize: requiredBufferSize);
    return encodedTum;
  }

  String encodeTumData(C.TumData cTumData) {
    Pointer<Pointer<Void>> tumPtrPtr = tumDataToPtrPtr(cTumData);
    int requiredBufferSize = 4096; 
    String encodedTumData = asnService.encodeTumData(tumPtrPtr, encodeBufferSize: requiredBufferSize);
    return encodedTumData;
  }

  int calculateRequiredBufferSize(C.TollUsageMessage tum) {
    int estimatedSize = 1024; // Base overhead
    
    // Add sizes of variable-length fields
    estimatedSize += tum.encryptedTumData.size;
    estimatedSize += tum.tempID.size;
    estimatedSize += tum.tollPointInfo.tollChargerId.size;
    
    if (tum.tumHash != nullptr) {
      final hashOctet = tum.tumHash.cast<C.OCTET_STRING>();
      estimatedSize += hashOctet.ref.size;
    }
    
    if (tum.tollPointInfo.descriptiveName != nullptr) {
      final nameOctet = tum.tollPointInfo.descriptiveName.cast<C.OCTET_STRING>();
      estimatedSize += nameOctet.ref.size;
    }
    
    // Add 50% safety margin for ASN.1 encoding overhead
    return (estimatedSize * 1.5).round();
  }

  Pointer<Pointer<Void>> tollUsageMessageToPtrPtr(C.TollUsageMessage message) {

    final Pointer<C.MessageFrame> messageFramePtr = calloc<C.MessageFrame>();
    messageFramePtr.ref.messageId = 38;
    messageFramePtr.ref.value.present = C.MessageFrame__value_PR.MessageFrame__value_PR_TollUsageMessage;
    messageFramePtr.ref.value.choice.TollUsageMessage = message;

    final Pointer<Pointer<Void>> ptrPtr = calloc<Pointer<Void>>();
    
    ptrPtr.value = messageFramePtr.cast<Void>();
    
    return ptrPtr;
  }

  Pointer<Pointer<Void>> tumDataToPtrPtr(C.TumData message) {

    final Pointer<C.TumData> tumDataFramePtr = calloc<C.TumData>();

    tumDataFramePtr.ref = message;

    final Pointer<Pointer<Void>> ptrPtr = calloc<Pointer<Void>>();
    
    ptrPtr.value = tumDataFramePtr.cast<Void>();
    
    return ptrPtr;
  }

  TollUsageMessageResult generateTumFromTam(TollAdvertisementMessage tam, List<int> vehicleIdList, DateTime sendTime){
    try {
      Vehicle selectedVehicle = configController.selectedVehicle.value;
      if (vehiclePathInTollZone.isEmpty) {
        return TollUsageMessageResult.error("No location data available to generate TUM");
      }
      LatLng mostRecentPosition = LatLng(
        vehiclePathInTollZone.last.latitude.latitude / 1E7,
        vehiclePathInTollZone.last.longitude.longitude / 1E7,
      );
      if (tam.tollAdvInfo == null) {
        throw Exception("TollAdvertisementMessage does not contain toll advertisement info");
      } else {
        TollChargerInfo tollPointInfo = tam.tollAdvInfo!.tollChargerInfo;
        TemporaryID tempId = TemporaryID(randomizeId()); 
        MsgCount tumSequenceNum = MsgCount(0);
        MsgCount tamSequenceNum = tam.tollAdvInfo!.tamSequenceNum; 

        // Skipping tumhash for now

        // EncryptedTumData
        // TollUserData
        DDateTime timestamp = DDateTime.fromDateTime(sendTime.toUtc()); 
        String tspId = tam.tollAdvInfo!.tollChargerInfo.tollChargerId; 
        
        // VehicleId
        String vehicleidentity =  vehicleIdList.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
        String licensePlateState = configController.selectedVehicle.value.licensePlateState.code;
        String licensePlateNumber = configController.selectedVehicle.value.licensePlateNumber;
        //skipping license plate num trailer for now
        ContractSerialNumber contractSerialNumber = ContractSerialNumber(012345678);
        UserId userId = UserId.fromDetails(null, contractSerialNumber, null, null, null);
        VehicleId vehicleId = VehicleId.fromDetails(vehicleidentity, licensePlateState, licensePlateNumber, null, userId);
        VehicleTypes vehicleType = VehicleMappingService.getVehicleTypes(selectedVehicle.classification);
        
        //VehicleAxlesAndWeightInfo
        int vehNumAxles = VehicleMappingService.getAxles(selectedVehicle.classification); 
        int vehWeight = VehicleMappingService.getWeight(selectedVehicle.classification); 
        VehicleAxlesAndWeightInfo vehicleAxlesAndWeightInfo = VehicleAxlesAndWeightInfo(vehNumAxles, null, vehWeight, VehicleMappingService.getDefaultWeightUnit(selectedVehicle.classification));
        int? numOccupants;

        // locAndTimeStamps
        int maxNumberOfLocTimeStamps = tam.tollAdvInfo!.tumInstructions!.maxNumOfLocTimeStamps.maxNumOfLocTimeStampsInteger; //Can be 5 as most
        int locTimeStampRate = tam.tollAdvInfo!.tumInstructions!.locTimeStampRate.locTimeStampRateInteger; //in Hz //Can be 10 at most
        List<LocAndTimeStamp> locAndTimeStampslist = getLocAndTimeStampsList(maxNumberOfLocTimeStamps, locTimeStampRate);
        LocAndTimeStamps locAndTimeStamps = LocAndTimeStamps(locAndTimeStampslist);
        
        //charge
        PaymentFeeResult paymentFeeResult = getPaymentFeeFromTam(tam, mostRecentPosition, numOccupants);
        if (!paymentFeeResult.isSuccess) {
          return TollUsageMessageResult.error(paymentFeeResult.errorMessage!);
        } 
        PaymentFee charge = paymentFeeResult.paymentFee!;


        // build toll user data
        TollUserData tollUserData = TollUserData(
          timestamp: timestamp,
          tspId: tspId,
          vehicleId: vehicleId,
          vehType: vehicleType,
          vehAxlesAndWeight: vehicleAxlesAndWeightInfo,
          numOccupants: numOccupants,
          locAndTimeStamps: locAndTimeStamps,
          charge: charge,
        );
        TumData tumData = TumData(
          tollUserData: tollUserData,
        );
        
        //Pointer for tumdata
        Pointer<C.TumData> tumDataPtr = calloc<C.TumData>();
        tumData.toC(tumDataPtr);  // This modifies tumDataPtr.ref in-place
        C.TumData cTumData = tumDataPtr.ref; 

        String encodedTumData = encodeTumData(cTumData);
        tumData.free(tumDataPtr); 

        EncryptedTumData encryptedTumData = EncryptedTumData(encodedTumData, tumData: tumData);

        TollUsageMessage tum = TollUsageMessage(
          tollPointInfo: tollPointInfo,
          tempID: tempId,
          tumSequenceNum: tumSequenceNum,
          tamSequenceNum: tamSequenceNum,
          encryptedTumData: encryptedTumData,
        );

        return TollUsageMessageResult.success(tum);

    }} catch (e) {
      return TollUsageMessageResult.error("Error generating TUM from TAM: $e");
    } 
  }

  String convertTumToHex(TollUsageMessage tum) {
    Pointer<C.TollUsageMessage> cTumPtr = calloc<C.TollUsageMessage>();
    tum.toC(cTumPtr);
    C.TollUsageMessage cTum = cTumPtr.ref;
    String encoded = encodeTum(cTum);
    tum.free(cTumPtr); 
    calloc.free(cTumPtr);
    return encoded;
  }


  String convertVehicleIdToOctetString(List<int> vehicleId) {
    return vehicleId.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  List<int> randomizeId() {
    List<int> randomId = List.generate(4, (_) => random.nextInt(255));
    return randomId;
  }

  List<T> takeLast<T>(List<T> list, int count) {
    if (list.isEmpty) return [];
    final start = list.length > count ? list.length - count : 0;
    return list.sublist(start);
  }

  List<LocAndTimeStamp> getLocAndTimeStampsList(int maxNumberOfLocTimeStamps, int locTimeStampRate) {
    List<LocAndTimeStamp> result = [];
    if (vehiclePathInTollZone.isEmpty) return [];
    const int currentRateHz = 10;

    if (locTimeStampRate == currentRateHz || locTimeStampRate > currentRateHz) {
      result = vehiclePathInTollZone;
    } else if (locTimeStampRate < currentRateHz) {
      int step = (currentRateHz / locTimeStampRate).round();
      for (int i = 0; i < vehiclePathInTollZone.length; i += step) {
        result.add(vehiclePathInTollZone[i]);
      }
    }
    if (result.length > maxNumberOfLocTimeStamps) {
      vehiclePathInTollZone.clear();
      if (maxNumberOfLocTimeStamps > result.length) {
        return result;
      } else {
        return result.sublist(0, maxNumberOfLocTimeStamps);
      }
    } else {
      return result;
    }
  }

  (double, String)? getPaymentFeeFromTamForApproach(TollAdvertisementMessage tam) {
    PaymentFeeResult paymentFeeResult = getPaymentFeeFromTam(tam, null, null, defaultLaneId: 1);
    if (paymentFeeResult.isSuccess) {
      (double, int) paymentAmount = paymentFeeResult.paymentFee!.getPaymentAmountWithUnit();
      String unit = ISO4217.getAlphabeticCode(paymentAmount.$2) ?? "Unknown Units";
      return (paymentAmount.$1, unit);
    } else {
      return null;
    }
  }
  
  PaymentFeeResult getPaymentFeeFromTam(TollAdvertisementMessage tam, LatLng? position, int? numOccupants, {int defaultLaneId = 1}) {
    TollTypeChargeChoice tollTypeCharge = tam.tollChargesTable.tollTypeCharge;
    if (tollTypeCharge.tollTypeCharge is TimeChargesTable) {
      return PaymentFeeResult.error("Time based charging not implemented"); //This fee is charge per minute. Time based chargine isn't implemented yet
    } else if (tollTypeCharge.tollTypeCharge is PerClosedNetworkChargesTable) {
      return PaymentFeeResult.error("Per closed network charging not implemented");
    } else if (tollTypeCharge.tollTypeCharge is PerLaneChargesTable) {
      PerLaneChargesTable perLaneChargesTable = tollTypeCharge.tollTypeCharge as PerLaneChargesTable;
      int? laneId; 
      if (position != null) {
        laneId = getLaneId(tam, position);
      } else {
        laneId = defaultLaneId;
      }
      laneId ??= defaultLaneId;
      LaneChargesTable? laneChargesTable = perLaneChargesTable.getLaneChargesTableFromLaneId(laneId); 
      if (laneChargesTable == null) {
        return PaymentFeeResult.error("Could not find charges for lane ID: $laneId");
      }
      ChargesTable chargesTable = laneChargesTable.chargesTable;
      return getPaymentFeeFromChargesTable(chargesTable, numOccupants);
    } else if (tollTypeCharge.tollTypeCharge is ChargesTable) {
      ChargesTable chargesTable = tollTypeCharge.tollTypeCharge as ChargesTable;
      return getPaymentFeeFromChargesTable(chargesTable, numOccupants);
    }
    return PaymentFeeResult.error("Unsupported toll type charge");
  }

  PaymentFeeResult getPaymentFeeFromChargesTable(ChargesTable chargesTable, int? numOccupants) {
    Vehicle selectedVehicle = configController.selectedVehicle.value;
    if (chargesTable.chargesTableChoice.chargesTableChoice is VehTypeChargesTable) {
      VehTypeChargesTable vehTypeCharges = chargesTable.chargesTableChoice.chargesTableChoice as VehTypeChargesTable;
      VehTypeCharges? vehTypeCharge = vehTypeCharges.getChargeForVehicleType(VehicleMappingService.getVehicleTypes(selectedVehicle.classification));
      if (vehTypeCharge == null) {
        return PaymentFeeResult.error("Could not determine vehicle type charge");
      }
      if (vehTypeCharge.specialCharges != null) {
        switch (numOccupants) {
          case 2:
            if (vehTypeCharge.specialCharges!.hov2Charge != null) {
              return PaymentFeeResult.success(vehTypeCharge.specialCharges!.hov2Charge!);
            }
            break;
          case 3:
            if (vehTypeCharge.specialCharges!.hov3Charge != null) {
              return PaymentFeeResult.success(vehTypeCharge.specialCharges!.hov3Charge!);
            }
            break;
          case 4:
            if (vehTypeCharge.specialCharges!.hov4Charge != null) {
              return PaymentFeeResult.success(vehTypeCharge.specialCharges!.hov4Charge!);
            }
            break;
          case 5:
            if (vehTypeCharge.specialCharges!.hov5PlusCharge != null) {
              return PaymentFeeResult.success(vehTypeCharge.specialCharges!.hov5PlusCharge!);
            }
            break;
          default:
            break;
        }
      }
      return PaymentFeeResult.success(vehTypeCharge.charges);
    } else if (chargesTable.chargesTableChoice.chargesTableChoice is AxlesChargesTable) {
      AxlesChargesTable numAxlesBased = chargesTable.chargesTableChoice.chargesTableChoice as AxlesChargesTable;
      AxlesCharges? axlesCharges  = numAxlesBased.getChargeForAxles(VehicleMappingService.getAxles(selectedVehicle.classification));
      if (axlesCharges == null) {
        return PaymentFeeResult.error("Could not determine axles charge");
      }
      return PaymentFeeResult.success(axlesCharges.axlesCharge);
    } else if (chargesTable.chargesTableChoice.chargesTableChoice is WeightChargesTable) {
      WeightChargesTable weightChargesTable = chargesTable.chargesTableChoice.chargesTableChoice as WeightChargesTable;
      WeightCharges? weightCharges = weightChargesTable.getChargeForWeight(VehicleMappingService.getWeight(selectedVehicle.classification)); //TODO: set based on vehicle config, create a mapping
      if (weightCharges == null) {
        return PaymentFeeResult.error("Could not determine weight charge");
      }
      if (weightCharges.weightCharge.weightChargesChoice is TotalWeightCharges) {
        TotalWeightCharges totalWeightCharges = weightCharges.weightCharge.weightChargesChoice as TotalWeightCharges;
        return PaymentFeeResult.success(totalWeightCharges.weightCharge);
      }
    }
    return PaymentFeeResult.error("Could not determine payment fee");
  }

  int? getLaneId(TollAdvertisementMessage tam, LatLng position) {
    TollZoneLanesMap tollZoneLanesMap = tam.tollAdvInfo!.tollPointMap.tollZoneLanesMap;
    double laneWidth = tam.tollAdvInfo!.tollPointMap.laneWidth.laneWidth * 0.01;
    for (var lane in tollZoneLanesMap.tollZoneLanesMap) {
      NodeListXY nodeList = lane.nodeList;
      Geometry? lanePolygon = geometryService.getGeometryFromNodeListXY(nodeList, tam.tollAdvInfo!.tollPointMap.referencePoint, laneWidth);
      if (lanePolygon == null) {
        continue;
      }
      bool isInLane = geometryService.isPointInPolygonWithMargin(lanePolygon, position.longitude, position.latitude, margin);
      if (isInLane) {
        return lane.laneID.laneID;
      }
    }
    return null; 
  }

  (double, String) getPaymentAmountFromTum(TollUsageMessage tum) {

    (double, int) paymentAmount = tum.encryptedTumData.tumData!.tollUserData.charge!.getPaymentAmountWithUnit();

    String unit = ISO4217.getAlphabeticCode(paymentAmount.$2) ?? "Unknown Units";
    return (paymentAmount.$1, unit);
  }
}

class PaymentFeeResult {
  final PaymentFee? paymentFee;
  final String? errorMessage;
  final bool isSuccess;

  PaymentFeeResult.success(this.paymentFee) 
      : errorMessage = null, isSuccess = true;
  
  PaymentFeeResult.error(this.errorMessage) 
      : paymentFee = null, isSuccess = false;
}

class TollUsageMessageResult {
  final TollUsageMessage? tollUsageMessage;
  final String? errorMessage;
  final bool isSuccess;

  TollUsageMessageResult.success(this.tollUsageMessage) 
      : errorMessage = null, isSuccess = true;
  
  TollUsageMessageResult.error(this.errorMessage) 
      : tollUsageMessage = null, isSuccess = false;
}