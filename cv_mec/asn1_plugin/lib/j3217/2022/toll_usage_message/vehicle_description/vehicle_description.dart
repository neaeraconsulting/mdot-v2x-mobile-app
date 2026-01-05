

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/actual_number_of_passengers.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/axle_weight_limits.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/diesel_emission_values.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/driver_characteristics.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/engine_details.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/exhaust_emission_values.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/passenger_capacity.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/sound_level.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/trailer_charcteristics.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_class.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_current_max_train_weight.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_dimensions.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_specifications.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_weight_laden.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/vehicle_weight_limits.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';


class VehicleDescription {
  VehicleClass? vehClass;
  VehicleDimensions? dimensions;
  VehicleSpecificCharacteristics? specificCharacteristics;
  VehicleWeightLaden? ladenWeight;
  VehicleWeightLimits? weightLimits;
  TrailerCharacteristics? trailerCharacteristics;
  VehicleCurrentMaxTrainWeight? vehicleCurrentMaxTrainWeight;
  ActualNumberOfPassengers? actualNumberOfPassengers;
  AxleWeightLimits? axleWeightLimits;
  DieselEmissionValues? dieselEmissionValues;
  DriverCharacteristics? driverCharacteristics;
  EngineDetails? engineDetails;
  ExhaustEmissionValues? exhaustEmissionValues;
  PassengerCapacity? passengerCapacity;
  SoundLevel? soundLevel;
  VehicleDescription.fromC(C.VehicleDescription c_obj){
    if(c_obj.Class != nullptr){
        vehClass = VehicleClass.fromC(c_obj.Class.value);
    }
    if(c_obj.dimensions.address != 0){
        dimensions = VehicleDimensions.fromC(c_obj.dimensions.ref);
    }
    if(c_obj.specificCharacteristics.address != 0){
        specificCharacteristics = VehicleSpecificCharacteristics.fromC(c_obj.specificCharacteristics.ref);
    }
    if(c_obj.ladenWeight.address != 0){
        ladenWeight = VehicleWeightLaden.fromC(c_obj.ladenWeight.value);
    }
    if(c_obj.weightLimits.address != 0){
        weightLimits = VehicleWeightLimits.fromC(c_obj.weightLimits.ref);
    }
    if(c_obj.trailerCharacteristics.address != 0){
        trailerCharacteristics = TrailerCharacteristics.fromC(c_obj.trailerCharacteristics.ref);
    }
    if(c_obj.vehicleCurrentMaxTrainWeight.address != 0){
        vehicleCurrentMaxTrainWeight = VehicleCurrentMaxTrainWeight(c_obj.vehicleCurrentMaxTrainWeight.value);
    }
    if(c_obj.actualNumberOfPassengers.address != 0){
        actualNumberOfPassengers = ActualNumberOfPassengers(c_obj.actualNumberOfPassengers.value);
    }
    if(c_obj.axleWeightLimits.address != 0){
        axleWeightLimits = AxleWeightLimits.fromC(c_obj.axleWeightLimits.ref);
    }
    if(c_obj.dieselEmissionValues.address != 0){
        dieselEmissionValues = DieselEmissionValues.fromC(c_obj.dieselEmissionValues.ref);
    }
    if(c_obj.driverCharacteristics.address != 0){
        driverCharacteristics = DriverCharacteristics.fromC(c_obj.driverCharacteristics.ref);
    }
    if(c_obj.engineDetails.address != 0){
        engineDetails = EngineDetails.fromC(c_obj.engineDetails.ref);
    }
    if(c_obj.exhaustEmissionValues.address != 0){
        exhaustEmissionValues = ExhaustEmissionValues.fromC(c_obj.exhaustEmissionValues.ref);
    }
    if(c_obj.passengerCapacity.address != 0){
        passengerCapacity = PassengerCapacity.fromC(c_obj.passengerCapacity.ref);
    }
    if(c_obj.soundLevel.address != 0){
        soundLevel = SoundLevel.fromC(c_obj.soundLevel.ref);
    }
  }

  void toC(Pointer<C.VehicleDescription> pointer) {
    final c_vehicleDesc = pointer.ref;

    pointer.cast<Uint8>().asTypedList(sizeOf<C.VehicleDescription>()).fillRange(0, sizeOf<C.VehicleDescription>(), 0);
    
    if (vehClass != null) {
        final classPtr = calloc<Int32>();
        classPtr.value = vehClass!.value;
        c_vehicleDesc.Class = classPtr as Pointer<C.VehicleClass_t>;
    } else {
        c_vehicleDesc.Class = nullptr;
    }
    
    if (dimensions != null) {
        final dimensionsPtr = calloc<C.VehicleDimensions>();
        dimensions!.toC(dimensionsPtr);
        c_vehicleDesc.dimensions = dimensionsPtr;
    } else {
        c_vehicleDesc.dimensions = nullptr;
    }
    
    if (specificCharacteristics != null) {
        final specificCharPtr = calloc<C.VehicleSpecificCharacteristics>();
        specificCharacteristics!.toC(specificCharPtr);
        c_vehicleDesc.specificCharacteristics = specificCharPtr;
    } else {
        c_vehicleDesc.specificCharacteristics = nullptr;
    }

    if (ladenWeight != null) {
        final ladenWeightPtr = calloc<Int32>();
        ladenWeightPtr.value = ladenWeight!.value;
        c_vehicleDesc.ladenWeight = ladenWeightPtr as Pointer<C.VehicleWeightLaden_t>;
    } else {
        c_vehicleDesc.ladenWeight = nullptr;
    }
    
    if (weightLimits != null) {
        final weightLimitsPtr = calloc<C.VehicleWeightLimits>();
        weightLimits!.toC(weightLimitsPtr);
        c_vehicleDesc.weightLimits = weightLimitsPtr;
    } else {
        c_vehicleDesc.weightLimits = nullptr;
    }
    
    if (trailerCharacteristics != null) {
        final trailerCharPtr = calloc<C.TrailerCharacteristics>();
        trailerCharacteristics!.toC(trailerCharPtr);
        c_vehicleDesc.trailerCharacteristics = trailerCharPtr;
    } else {
        c_vehicleDesc.trailerCharacteristics = nullptr;
    }
    
    if (vehicleCurrentMaxTrainWeight != null) {
        final maxTrainWeightPtr = calloc<Int32>();
        maxTrainWeightPtr.value = vehicleCurrentMaxTrainWeight!.value;
        c_vehicleDesc.vehicleCurrentMaxTrainWeight = maxTrainWeightPtr as Pointer<C.VehicleCurrentMaxTrainWeight_t>;
    } else {
        c_vehicleDesc.vehicleCurrentMaxTrainWeight = nullptr;
    }
    
    if (actualNumberOfPassengers != null) {
        final passengersPtr = calloc<Int32>();
        passengersPtr.value = actualNumberOfPassengers!.value;
        c_vehicleDesc.actualNumberOfPassengers = passengersPtr as Pointer<C.ActualNumberOfPassengers_t>;
    } else {
        c_vehicleDesc.actualNumberOfPassengers = nullptr;
    }
    
    if (axleWeightLimits != null) {
        final axleWeightPtr = calloc<C.AxleWeightLimits>();
        axleWeightLimits!.toC(axleWeightPtr);
        c_vehicleDesc.axleWeightLimits = axleWeightPtr;
    } else {
        c_vehicleDesc.axleWeightLimits = nullptr;
    }
    
    if (dieselEmissionValues != null) {
        final dieselEmissionPtr = calloc<C.DieselEmissionValues>();
        dieselEmissionValues!.toC(dieselEmissionPtr);
        c_vehicleDesc.dieselEmissionValues = dieselEmissionPtr;
    } else {
        c_vehicleDesc.dieselEmissionValues = nullptr;
    }
    
    if (driverCharacteristics != null) {
        final driverCharPtr = calloc<C.DriverCharacteristics>();
        driverCharacteristics!.toC(driverCharPtr);
        c_vehicleDesc.driverCharacteristics = driverCharPtr;
    } else {
        c_vehicleDesc.driverCharacteristics = nullptr;
    }
    
    if (engineDetails != null) {
        final engineDetailsPtr = calloc<C.EngineDetails>();
        engineDetails!.toC(engineDetailsPtr);
        c_vehicleDesc.engineDetails = engineDetailsPtr;
    } else {
        c_vehicleDesc.engineDetails = nullptr;
    }
    
    if (exhaustEmissionValues != null) {
        final exhaustEmissionPtr = calloc<C.ExhaustEmissionValues>();
        exhaustEmissionValues!.toC(exhaustEmissionPtr);
        c_vehicleDesc.exhaustEmissionValues = exhaustEmissionPtr;
    } else {
        c_vehicleDesc.exhaustEmissionValues = nullptr;
    }
    
    if (passengerCapacity != null) {
        final passengerCapPtr = calloc<C.PassengerCapacity>();
        passengerCapacity!.toC(passengerCapPtr);
        c_vehicleDesc.passengerCapacity = passengerCapPtr;
    } else {
        c_vehicleDesc.passengerCapacity = nullptr;
    }
    
    if (soundLevel != null) {
        final soundLevelPtr = calloc<C.SoundLevel>();
        soundLevel!.toC(soundLevelPtr);
        c_vehicleDesc.soundLevel = soundLevelPtr;
    } else {
        c_vehicleDesc.soundLevel = nullptr;
    }
  }
  
  void free(Pointer<C.VehicleDescription> pointer) {
    final c_vehicleDesc = pointer.ref;

    if (c_vehicleDesc.Class != nullptr) {
        calloc.free(c_vehicleDesc.Class);
        c_vehicleDesc.Class = nullptr;
    }

    if (c_vehicleDesc.dimensions != nullptr) {
        dimensions!.free(c_vehicleDesc.dimensions);
        c_vehicleDesc.dimensions = nullptr;
    }

    if (c_vehicleDesc.specificCharacteristics != nullptr) {
        specificCharacteristics!.free(c_vehicleDesc.specificCharacteristics);
        c_vehicleDesc.specificCharacteristics = nullptr;
    }

    if (c_vehicleDesc.ladenWeight != nullptr) {
        calloc.free(c_vehicleDesc.ladenWeight);
        c_vehicleDesc.ladenWeight = nullptr;
    }

    if (c_vehicleDesc.weightLimits != nullptr) {
        weightLimits!.free(c_vehicleDesc.weightLimits);
        c_vehicleDesc.weightLimits = nullptr;
    }

    if (c_vehicleDesc.trailerCharacteristics != nullptr) {
        trailerCharacteristics!.free(c_vehicleDesc.trailerCharacteristics);
        c_vehicleDesc.trailerCharacteristics = nullptr;
    }

    if (c_vehicleDesc.vehicleCurrentMaxTrainWeight != nullptr) {
        calloc.free(c_vehicleDesc.vehicleCurrentMaxTrainWeight);
        c_vehicleDesc.vehicleCurrentMaxTrainWeight = nullptr;
    }

    if (c_vehicleDesc.actualNumberOfPassengers != nullptr) {
        calloc.free(c_vehicleDesc.actualNumberOfPassengers);
        c_vehicleDesc.actualNumberOfPassengers = nullptr;
    }

    if (c_vehicleDesc.axleWeightLimits != nullptr) {
        axleWeightLimits!.free(c_vehicleDesc.axleWeightLimits);
        c_vehicleDesc.axleWeightLimits = nullptr;
    }

    if (c_vehicleDesc.dieselEmissionValues != nullptr) {
        dieselEmissionValues!.free(c_vehicleDesc.dieselEmissionValues);
        c_vehicleDesc.dieselEmissionValues = nullptr;
    }

    if (c_vehicleDesc.driverCharacteristics != nullptr) {
        driverCharacteristics!.free(c_vehicleDesc.driverCharacteristics);
        c_vehicleDesc.driverCharacteristics = nullptr;
    }

    if (c_vehicleDesc.engineDetails != nullptr) {
        engineDetails!.free(c_vehicleDesc.engineDetails);
        c_vehicleDesc.engineDetails = nullptr;
    }

    if (c_vehicleDesc.exhaustEmissionValues != nullptr) {
        exhaustEmissionValues!.free(c_vehicleDesc.exhaustEmissionValues);
        c_vehicleDesc.exhaustEmissionValues = nullptr;
    }

    if (c_vehicleDesc.passengerCapacity != nullptr) {
        passengerCapacity!.free(c_vehicleDesc.passengerCapacity);
        c_vehicleDesc.passengerCapacity = nullptr;
    }
  }
}






