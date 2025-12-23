import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:asn1_plugin/j2735/2024/common/d_date_time.dart';
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
import 'package:asn1_plugin/j3217/2022/toll_usage_message/encrypted_tum_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamp.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/loc_and_time_stamps.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/toll_usage_message.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/toll_user_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/tum_data.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_axles_and_weight_info.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_id.dart';
import 'package:cv_mec/controllers/configuration_controller.dart';
import 'package:cv_mec/models/test_data.dart';
import 'package:cv_mec/models/vehicle.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:cv_mec/services/vehicle_mapping_service.dart';
import 'package:ffi/ffi.dart';
import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:cv_mec/services/asn_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class TumBuilder{

  ASNService asnService = Get.find<ASNService>();
  Random random = Random();
  TumBuilder();
  ConfigurationController configController = Get.find<ConfigurationController>();
  final List<Pointer> _allocatedPointers = [];

  C.TollUsageMessage buildCTum(TollUsageMessage tum) {
    final tumPtr = _allocate(calloc<C.TollUsageMessage>());
    tum.toC(tumPtr);
    return tumPtr.ref;
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

  T _allocate<T extends Pointer>(T pointer) {
    _allocatedPointers.add(pointer);
    return pointer;
  }

  void _cleanup() {
    for (var pointer in _allocatedPointers) {
      try {
        calloc.free(pointer);
      } catch (e) {
        print("Error freeing pointer: $e");
      }
    }
    _allocatedPointers.clear();
  }

  Pointer<Pointer<Void>> tollUsageMessageToPtrPtr(C.TollUsageMessage message) {

    final Pointer<C.MessageFrame> messageFramePtr = _allocate(calloc<C.MessageFrame>());

    messageFramePtr.ref.messageId = 38;
    messageFramePtr.ref.value.present = C.MessageFrame__value_PR.MessageFrame__value_PR_TollUsageMessage;
    messageFramePtr.ref.value.choice.TollUsageMessage = message;

    final Pointer<Pointer<Void>> ptrPtr = _allocate(calloc<Pointer<Void>>());
    
    ptrPtr.value = messageFramePtr.cast<Void>();
    
    return ptrPtr;
  }

  Pointer<Pointer<Void>> tumDataToPtrPtr(C.TumData message) {

    final Pointer<C.TumData> tumDataFramePtr = _allocate(calloc<C.TumData>());

    tumDataFramePtr.ref = message;

    final Pointer<Pointer<Void>> ptrPtr = _allocate(calloc<Pointer<Void>>());
    
    ptrPtr.value = tumDataFramePtr.cast<Void>();
    
    return ptrPtr;
  }

  TollUsageMessageResult generateTumFromTam(TollAdvertisementMessage tam, List<LocAndTimeStamp> historicalVehiclePath, Position currentPosition, List<int> vehicleIdList, DateTime sendTime){
    try {
    Vehicle selectedVehicle = configController.selectedVehicle.value;
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
      //skipping user id 
      VehicleId vehicleId = VehicleId.fromDetails(vehicleidentity, licensePlateState, licensePlateNumber);
      
      VehicleTypes vehicleType = VehicleMappingService.getVehicleTypes(selectedVehicle.classification);
      
      //VehicleAxlesAndWeightInfo
      int vehNumAxles = VehicleMappingService.getAxles(selectedVehicle.classification); //TODO: set based on vehicle config, create a mapping
      int vehWeight = VehicleMappingService.getWeight(selectedVehicle.classification); //TODO: set based on vehicle config, create a mapping
      VehicleAxlesAndWeightInfo vehicleAxlesAndWeightInfo = VehicleAxlesAndWeightInfo(vehNumAxles, null, vehWeight, VehicleMappingService.getDefaultWeightUnit(selectedVehicle.classification));
      int? numOccupants;
      if (configController.isHovOn.value) {
        numOccupants = VehicleMappingService.getNumOccupants(selectedVehicle.classification); //TODO: set based on vehicle config, create a mapping
        if (numOccupants > 5) {
          numOccupants = 5; //Based on J3217 saying if numOccupants is 5 or greater, then set numOccupants to 5
        }
      }

      // Skipping entrytollpointid for the moment
      // skipping entryTimestamp for the moment

      // locAndTimeStamps
      int maxNumberOfLocTimeStamps = tam.tollAdvInfo!.tumInstructions!.maxNumOfLocTimeStamps.maxNumOfLocTimeStampsInteger;
      int locTimeStampRate = tam.tollAdvInfo!.tumInstructions!.locTimeStampRate.locTimeStampRateInteger; //in Hz
      List<LocAndTimeStamp> locAndTimeStampslist = getLocAndTimeStampsList(historicalVehiclePath, maxNumberOfLocTimeStamps, locTimeStampRate);
      LocAndTimeStamps locAndTimeStamps = LocAndTimeStamps(locAndTimeStampslist);
      
      //charge
      PaymentFeeResult paymentFeeResult = getPaymentFeeFromTam(tam, currentPosition, numOccupants);
      if (paymentFeeResult.paymentFee == null) {
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
      Pointer<C.TumData> tumDataPtr = _allocate(calloc<C.TumData>());
      tumData.toC(tumDataPtr);  // This modifies tumDataPtr.ref in-place
      C.TumData cTumData = tumDataPtr.ref; 
      
      String encodedTumData = encodeTumData(cTumData);

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
    } finally {
      _cleanup();
    }
  }

  String convertTumToHex(TollUsageMessage tum) {
    C.TollUsageMessage cTum = buildCTum(tum);
    String encoded = encodeTum(cTum);
    return encoded;
  }

  String convertVehicleIdToOctetString(List<int> vehicleId) {
    return vehicleId.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  List<int> randomizeId() {
    List<int> randomId = List.generate(4, (_) => random.nextInt(255));
    return randomId;
  }

  VehicleTypes convertVehicleClassificationToVehicleTypes(VehicleType classification) {
    switch (classification) {
      case VehicleType.PASSENGER_VEHICLE:
        return VehicleTypes.passengerCars;
      case VehicleType.BUS:
        return VehicleTypes.buses;
      case VehicleType.LIGHT_TRUCK:
        return VehicleTypes.fourTireSingleUnit;
      case VehicleType.TRUCK:
        return VehicleTypes.fourOrMoreAxleSingleUnit;
      case VehicleType.MOTORCYCLE:
        return VehicleTypes.motorcycles;
      case VehicleType.FIRE:
        return VehicleTypes.twoAxleSixTireSingleUnit;
      default:
        return VehicleTypes.fourTireSingleUnit;
    }
  }

  List<T> takeLast<T>(List<T> list, int count) {
    if (list.isEmpty) return [];
    final start = list.length > count ? list.length - count : 0;
    return list.sublist(start);
  }

  List<LocAndTimeStamp> getLocAndTimeStampsList(List<LocAndTimeStamp> historicalVehiclePath, int maxNumberOfLocTimeStamps, int locTimeStampRate) {
    List<LocAndTimeStamp> result = [];
    if (historicalVehiclePath.isEmpty) return [];
    const int currentRateHz = 10;

    if (locTimeStampRate == currentRateHz || locTimeStampRate > currentRateHz) {
      result = historicalVehiclePath.reversed.toList();
    } else if (locTimeStampRate < currentRateHz) {
      int step = (currentRateHz / locTimeStampRate).round();
      for (int i = historicalVehiclePath.length - 1; i >= 0; i -= step) {
        result.add(historicalVehiclePath[i]);
      }
    }
    if (result.length > maxNumberOfLocTimeStamps) {
      return result.sublist(0, maxNumberOfLocTimeStamps);
    } else {
      return result;
    }
  }
  
  PaymentFeeResult getPaymentFeeFromTam(TollAdvertisementMessage tam, Position currentPosition, int? numOccupants) {
    TollTypeChargeChoice tollTypeCharge = tam.tollChargesTable.tollTypeCharge;
    if (tollTypeCharge.tollTypeCharge is TimeChargesTable) {
      //TimeChargesTable pointCharges = tollTypeCharge.tollTypeCharge as TimeChargesTable;
      //ChargesTable chargesTable = pointCharges.chargesTable;
      //PaymentFeeResult paymentFeeResult = getPaymentFeeFromChargesTable(chargesTable, numOccupants); 
      return PaymentFeeResult.error("Time based charging not implemented"); //This fee is charge per minute. Time based chargine isn't implemented yet
    } else if (tollTypeCharge.tollTypeCharge is PerClosedNetworkChargesTable) {
      //PerClosedNetworkChargesTable perClosedNetworkChargesTable = tollTypeCharge.tollTypeCharge as PerClosedNetworkChargesTable;
      return PaymentFeeResult.error("Per closed network charging not implemented");
    } else if (tollTypeCharge.tollTypeCharge is PerLaneChargesTable) {
      PerLaneChargesTable perLaneChargesTable = tollTypeCharge.tollTypeCharge as PerLaneChargesTable;
      int? laneId = getLaneId(tam, currentPosition);
      if (laneId == null) {
        return PaymentFeeResult.error("Could not determine lane ID for per-lane charges");
      }
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

  int? getLaneId(TollAdvertisementMessage tam, Position currentPosition) {
    TollZoneLanesMap tollZoneLanesMap = tam.tollAdvInfo!.tollPointMap.tollZoneLanesMap;
    double laneWidth = tam.tollAdvInfo!.tollPointMap.laneWidth.laneWidth * 0.01;
    GeometryService geometryService = Get.find<GeometryService>();
    for (var lane in tollZoneLanesMap.tollZoneLanesMap) {
      NodeListXY nodeList = lane.nodeList;
      if (nodeList.nodeListXY is NodeSetXY) {
          NodeSetXY nodeSet = nodeList.nodeListXY as NodeSetXY;
          List<LatLng> lanePoints = geometryService.getLatLngCoordinatesFromNodeSetXY(nodeSet, tam.tollAdvInfo!.tollPointMap.referencePoint);
          List<LatLng> lanePolygon = generateLanePolygon(lanePoints, laneWidth);
          lanePolygon.add(lanePolygon.first); // Close the polygon
          bool isInLane = isPointInPolygon(currentPosition, lanePolygon);
          if (isInLane) {
            return lane.laneID.laneID;
          }
      }
    }
    return null; 
  }

  List<LatLng> generateLanePolygon(List<LatLng> centerlinePoints, double laneWidthMeters) {
    if (centerlinePoints.length < 2) return [];
    
    List<LatLng> leftBoundary = [];
    List<LatLng> rightBoundary = [];
    
    for (int i = 0; i < centerlinePoints.length; i++) {
      LatLng current = centerlinePoints[i];
      
      // Calculate perpendicular direction
      double bearing;
      if (i == 0) {
        // First point: use direction to next point
        bearing = _calculateBearing(current, centerlinePoints[i + 1]);
      } else if (i == centerlinePoints.length - 1) {
        // Last point: use direction from previous point
        bearing = _calculateBearing(centerlinePoints[i - 1], current);
      } else {
        // Middle points: average of incoming and outgoing directions
        double bearing1 = _calculateBearing(centerlinePoints[i - 1], current);
        double bearing2 = _calculateBearing(current, centerlinePoints[i + 1]);
        bearing = (bearing1 + bearing2) / 2;
      }
      
      // Calculate perpendicular bearings (90 degrees left and right)
      double leftBearing = bearing + 90;
      double rightBearing = bearing - 90;
      
      // Calculate offset points
      LatLng leftPoint = _offsetLatLng(current, leftBearing, laneWidthMeters / 2);
      LatLng rightPoint = _offsetLatLng(current, rightBearing, laneWidthMeters / 2);
      
      leftBoundary.add(leftPoint);
      rightBoundary.add(rightPoint);
    }
    
    // Create closed polygon: left boundary + reversed right boundary
    List<LatLng> polygon = [...leftBoundary, ...rightBoundary.reversed];
    return polygon;
  }
  
  LatLng _offsetLatLng(LatLng start, double bearingDegrees, double distanceMeters) {
    const double earthRadius = 6378137.0; // Earth's radius in meters
    double bearingRad = bearingDegrees * (pi / 180);
    double latRad = start.latitude * (pi / 180);
    double lonRad = start.longitude * (pi / 180);
    
    double newLatRad = asin(sin(latRad) * cos(distanceMeters / earthRadius) +
        cos(latRad) * sin(distanceMeters / earthRadius) * cos(bearingRad));
    
    double newLonRad = lonRad + atan2(
        sin(bearingRad) * sin(distanceMeters / earthRadius) * cos(latRad),
        cos(distanceMeters / earthRadius) - sin(latRad) * sin(newLatRad));
    
    return LatLng(newLatRad * (180 / pi), newLonRad * (180 / pi));
  }
  
  double _calculateBearing(LatLng start, LatLng end) {
    double lat1Rad = start.latitude * (pi / 180);
    double lat2Rad = end.latitude * (pi / 180);
    double deltaLonRad = (end.longitude - start.longitude) * (pi / 180);
    
    double y = sin(deltaLonRad) * cos(lat2Rad);
    double x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad);
    
    return atan2(y, x) * (180 / pi);
  }
  
  // point-in-polygon check (ray casting algorithm)
  bool isPointInPolygon(Position point, List<LatLng> laneBorder) {
    
    LatLng position = LatLng(point.latitude, point.longitude);
    // check if position is within the polygon that is defined by laneBorder
    int i, j = laneBorder.length - 1;
    bool inside = false;
    for (i = 0; i < laneBorder.length; j = i++) {
      if (((laneBorder[i].longitude > position.longitude) != (laneBorder[j].longitude > position.longitude)) &&
          (position.latitude <
              (laneBorder[j].latitude - laneBorder[i].latitude) * (position.longitude - laneBorder[i].longitude) /
                      (laneBorder[j].longitude - laneBorder[i].longitude) +
                  laneBorder[i].latitude)) {
        inside = !inside;
      }
    }
    return inside;
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