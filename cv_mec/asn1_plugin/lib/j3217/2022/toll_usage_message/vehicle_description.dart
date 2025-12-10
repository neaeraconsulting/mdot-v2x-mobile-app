

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

//TODO: Split classes into separate files

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
        
        // Clean up existing allocations first
        _cleanupExistingAllocations(c_vehicleDesc);
        
        // Zero-initialize the struct
        pointer.cast<Uint8>().asTypedList(sizeOf<C.VehicleDescription>()).fillRange(0, sizeOf<C.VehicleDescription>(), 0);
        
        // Handle vehClass (pointer to int value)
        if (vehClass != null) {
            final classPtr = calloc<Int32>();
            classPtr.value = vehClass!.value;
            c_vehicleDesc.Class = classPtr as Pointer<C.VehicleClass_t>;
        } else {
            c_vehicleDesc.Class = nullptr;
        }
        
        // Handle dimensions (pointer to struct)
        if (dimensions != null) {
            final dimensionsPtr = calloc<C.VehicleDimensions>();
            dimensions!.toC(dimensionsPtr);
            c_vehicleDesc.dimensions = dimensionsPtr;
        } else {
            c_vehicleDesc.dimensions = nullptr;
        }
        
        // Handle specificCharacteristics (pointer to struct)
        if (specificCharacteristics != null) {
            final specificCharPtr = calloc<C.VehicleSpecificCharacteristics>();
            specificCharacteristics!.toC(specificCharPtr);
            c_vehicleDesc.specificCharacteristics = specificCharPtr;
        } else {
            c_vehicleDesc.specificCharacteristics = nullptr;
        }
        
        // Handle ladenWeight (pointer to int value)
        if (ladenWeight != null) {
            final ladenWeightPtr = calloc<Int32>();
            ladenWeightPtr.value = ladenWeight!.value;
            c_vehicleDesc.ladenWeight = ladenWeightPtr as Pointer<C.VehicleWeightLaden_t>;
        } else {
            c_vehicleDesc.ladenWeight = nullptr;
        }
        
        // Handle weightLimits (pointer to struct)
        if (weightLimits != null) {
            final weightLimitsPtr = calloc<C.VehicleWeightLimits>();
            weightLimits!.toC(weightLimitsPtr);
            c_vehicleDesc.weightLimits = weightLimitsPtr;
        } else {
            c_vehicleDesc.weightLimits = nullptr;
        }
        
        // Handle trailerCharacteristics (pointer to struct)
        if (trailerCharacteristics != null) {
            final trailerCharPtr = calloc<C.TrailerCharacteristics>();
            trailerCharacteristics!.toC(trailerCharPtr);
            c_vehicleDesc.trailerCharacteristics = trailerCharPtr;
        } else {
            c_vehicleDesc.trailerCharacteristics = nullptr;
        }
        
        // Handle vehicleCurrentMaxTrainWeight (pointer to int value)
        if (vehicleCurrentMaxTrainWeight != null) {
            final maxTrainWeightPtr = calloc<Int32>();
            maxTrainWeightPtr.value = vehicleCurrentMaxTrainWeight!.value;
            c_vehicleDesc.vehicleCurrentMaxTrainWeight = maxTrainWeightPtr as Pointer<C.VehicleCurrentMaxTrainWeight_t>;
        } else {
            c_vehicleDesc.vehicleCurrentMaxTrainWeight = nullptr;
        }
        
        // Handle actualNumberOfPassengers (pointer to int value)
        if (actualNumberOfPassengers != null) {
            final passengersPtr = calloc<Int32>();
            passengersPtr.value = actualNumberOfPassengers!.value;
            c_vehicleDesc.actualNumberOfPassengers = passengersPtr as Pointer<C.ActualNumberOfPassengers_t>;
        } else {
            c_vehicleDesc.actualNumberOfPassengers = nullptr;
        }
        
        // Handle axleWeightLimits (pointer to struct)
        if (axleWeightLimits != null) {
            final axleWeightPtr = calloc<C.AxleWeightLimits>();
            axleWeightLimits!.toC(axleWeightPtr);
            c_vehicleDesc.axleWeightLimits = axleWeightPtr;
        } else {
            c_vehicleDesc.axleWeightLimits = nullptr;
        }
        
        // Handle dieselEmissionValues (pointer to struct)
        if (dieselEmissionValues != null) {
            final dieselEmissionPtr = calloc<C.DieselEmissionValues>();
            dieselEmissionValues!.toC(dieselEmissionPtr);
            c_vehicleDesc.dieselEmissionValues = dieselEmissionPtr;
        } else {
            c_vehicleDesc.dieselEmissionValues = nullptr;
        }
        
        // Handle driverCharacteristics (pointer to struct)
        if (driverCharacteristics != null) {
            final driverCharPtr = calloc<C.DriverCharacteristics>();
            driverCharacteristics!.toC(driverCharPtr);
            c_vehicleDesc.driverCharacteristics = driverCharPtr;
        } else {
            c_vehicleDesc.driverCharacteristics = nullptr;
        }
        
        // Handle engineDetails (pointer to struct)
        if (engineDetails != null) {
            final engineDetailsPtr = calloc<C.EngineDetails>();
            engineDetails!.toC(engineDetailsPtr);
            c_vehicleDesc.engineDetails = engineDetailsPtr;
        } else {
            c_vehicleDesc.engineDetails = nullptr;
        }
        
        // Handle exhaustEmissionValues (pointer to struct)
        if (exhaustEmissionValues != null) {
            final exhaustEmissionPtr = calloc<C.ExhaustEmissionValues>();
            exhaustEmissionValues!.toC(exhaustEmissionPtr);
            c_vehicleDesc.exhaustEmissionValues = exhaustEmissionPtr;
        } else {
            c_vehicleDesc.exhaustEmissionValues = nullptr;
        }
        
        // Handle passengerCapacity (pointer to struct)
        if (passengerCapacity != null) {
            final passengerCapPtr = calloc<C.PassengerCapacity>();
            passengerCapacity!.toC(passengerCapPtr);
            c_vehicleDesc.passengerCapacity = passengerCapPtr;
        } else {
            c_vehicleDesc.passengerCapacity = nullptr;
        }
        
        // Handle soundLevel (pointer to struct)
        if (soundLevel != null) {
            final soundLevelPtr = calloc<C.SoundLevel>();
            soundLevel!.toC(soundLevelPtr);
            c_vehicleDesc.soundLevel = soundLevelPtr;
        } else {
            c_vehicleDesc.soundLevel = nullptr;
        }
    }
    
    // Helper method to clean up existing allocations
    void _cleanupExistingAllocations(C.VehicleDescription c_vehicleDesc) {
        if (c_vehicleDesc.Class != nullptr) {
            calloc.free(c_vehicleDesc.Class);
            c_vehicleDesc.Class = nullptr;
        }
        
        if (c_vehicleDesc.dimensions != nullptr) {
            calloc.free(c_vehicleDesc.dimensions);
            c_vehicleDesc.dimensions = nullptr;
        }
        
        if (c_vehicleDesc.specificCharacteristics != nullptr) {
            calloc.free(c_vehicleDesc.specificCharacteristics);
            c_vehicleDesc.specificCharacteristics = nullptr;
        }
        
        if (c_vehicleDesc.ladenWeight != nullptr) {
            calloc.free(c_vehicleDesc.ladenWeight);
            c_vehicleDesc.ladenWeight = nullptr;
        }
        
        if (c_vehicleDesc.weightLimits != nullptr) {
            calloc.free(c_vehicleDesc.weightLimits);
            c_vehicleDesc.weightLimits = nullptr;
        }
        
        if (c_vehicleDesc.trailerCharacteristics != nullptr) {
            calloc.free(c_vehicleDesc.trailerCharacteristics);
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
            calloc.free(c_vehicleDesc.axleWeightLimits);
            c_vehicleDesc.axleWeightLimits = nullptr;
        }
        
        if (c_vehicleDesc.dieselEmissionValues != nullptr) {
            calloc.free(c_vehicleDesc.dieselEmissionValues);
            c_vehicleDesc.dieselEmissionValues = nullptr;
        }
        
        if (c_vehicleDesc.driverCharacteristics != nullptr) {
            calloc.free(c_vehicleDesc.driverCharacteristics);
            c_vehicleDesc.driverCharacteristics = nullptr;
        }
        
        if (c_vehicleDesc.engineDetails != nullptr) {
            calloc.free(c_vehicleDesc.engineDetails);
            c_vehicleDesc.engineDetails = nullptr;
        }
        
        if (c_vehicleDesc.exhaustEmissionValues != nullptr) {
            calloc.free(c_vehicleDesc.exhaustEmissionValues);
            c_vehicleDesc.exhaustEmissionValues = nullptr;
        }
        
        if (c_vehicleDesc.passengerCapacity != nullptr) {
            calloc.free(c_vehicleDesc.passengerCapacity);
            c_vehicleDesc.passengerCapacity = nullptr;
        }
        
        if (c_vehicleDesc.soundLevel != nullptr) {
            calloc.free(c_vehicleDesc.soundLevel);
            c_vehicleDesc.soundLevel = nullptr;
        }
    }
}

class VehicleClass {
    late int value;
    VehicleClass.fromC(int val): value = val;
}

class VehicleDimensions {
    late int vehicleLengthOverall;
    late int vehicleHeigthOverall;
    late int vehicleWidthOverall;
    VehicleDimensions.fromC(C.VehicleDimensions c_obj):
        vehicleLengthOverall = c_obj.vehicleLengthOverall,
        vehicleHeigthOverall = c_obj.vehicleHeigthOverall,
        vehicleWidthOverall = c_obj.vehicleWidthOverall;

    void toC(Pointer<C.VehicleDimensions> pointer) {
        final c_dimensions = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_dimensions.vehicleLengthOverall = vehicleLengthOverall;
        c_dimensions.vehicleHeigthOverall = vehicleHeigthOverall;
        c_dimensions.vehicleWidthOverall = vehicleWidthOverall;
    }
}

class VehicleSpecificCharacteristics {
  late int engineCharacteristics;
  late int descriptiveCharacteristics;
  late int futureCharacteristics;
  late EnvironmentalCharacteristics environmentalCharacteristics;
  VehicleSpecificCharacteristics.fromC(C.VehicleSpecificCharacteristics c_obj){
      engineCharacteristics = c_obj.engineCharacteristics;
      descriptiveCharacteristics = c_obj.descriptiveCharacteristics;
      futureCharacteristics = c_obj.futureCharacteristics;
      environmentalCharacteristics = EnvironmentalCharacteristics.fromC(c_obj.environmentalCharacteristics);
  }

  void toC(Pointer<C.VehicleSpecificCharacteristics> pointer) {
      final c_specificChar = pointer.ref;
      
      // These are direct struct fields (not pointers), so assign directly
      c_specificChar.engineCharacteristics = engineCharacteristics;
      c_specificChar.descriptiveCharacteristics = descriptiveCharacteristics;
      c_specificChar.futureCharacteristics = futureCharacteristics;
      
      // Handle environmentalCharacteristics (embedded struct)
      environmentalCharacteristics.toC(Pointer.fromAddress(
          pointer.address + _getEnvironmentalCharacteristicsOffset()
      ));
  }
  
  // Helper method to get the offset of environmentalCharacteristics field
  int _getEnvironmentalCharacteristicsOffset() {
      // Calculate offset: 3 integers before environmentalCharacteristics
      return sizeOf<Int32>() * 3;
  }
}

class EnvironmentalCharacteristics {
    late int euroValue;
    late int copValue;
    EnvironmentalCharacteristics.fromC(C.EnvironmentalCharacteristics c_obj):
        euroValue = c_obj.euroValue,
        copValue = c_obj.copValue;
    void toC(Pointer<C.EnvironmentalCharacteristics> pointer) {
        final c_envChar = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_envChar.euroValue = euroValue;
        c_envChar.copValue = copValue;
    }
}

class VehicleWeightLaden {
    late int value;
    VehicleWeightLaden.fromC(int val): value = val;
}

class VehicleWeightLimits {
    late int vehicleMaxLadenWeight;
    late int vehicleTrainMaximumWeight;
    late int vehicleWeightUnladen;
    VehicleWeightLimits.fromC(C.VehicleWeightLimits c_obj):
        vehicleMaxLadenWeight = c_obj.vehicleMaxLadenWeight,
        vehicleTrainMaximumWeight = c_obj.vehicleTrainMaximumWeight,
        vehicleWeightUnladen = c_obj.vehicleWeightUnladen;

    void toC(Pointer<C.VehicleWeightLimits> pointer) {
        final c_weightLimits = pointer.ref;
        c_weightLimits.vehicleMaxLadenWeight = vehicleMaxLadenWeight;
        c_weightLimits.vehicleTrainMaximumWeight = vehicleTrainMaximumWeight;
        c_weightLimits.vehicleWeightUnladen = vehicleWeightUnladen;
    }
}

class TrailerCharacteristics {
    late TrailerDetails trailerDetails;
    late int trailerMaxLadenWeight;
    late int trailerWeightUnladen;
    TrailerCharacteristics.fromC(C.TrailerCharacteristics c_obj){
        trailerDetails = TrailerDetails.fromC(c_obj.trailerDetails);
        trailerMaxLadenWeight = c_obj.trailerMaxLadenWeight;
        trailerWeightUnladen = c_obj.trailerWeightUnladen;
    }

    void toC(Pointer<C.TrailerCharacteristics> pointer) {
        final c_trailerChar = pointer.ref;
        
        // Handle trailerDetails (embedded struct)
        trailerDetails.toC(Pointer.fromAddress(
            pointer.address // trailerDetails is likely the first field
        ));
        
        // Handle trailerMaxLadenWeight (direct int field)
        c_trailerChar.trailerMaxLadenWeight = trailerMaxLadenWeight;
        
        // Handle trailerWeightUnladen (direct int field)
        c_trailerChar.trailerWeightUnladen = trailerWeightUnladen;
    }

    
}

class TrailerDetails {
    late int trailerType;
    late int trailerAxles;
    TrailerDetails.fromC(C.TrailerDetails c_obj):
        trailerType = c_obj.trailerType,
        trailerAxles = c_obj.trailerAxles;
    
    void toC(Pointer<C.TrailerDetails> pointer) {
        final c_trailerDetails = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_trailerDetails.trailerType = trailerType;
        c_trailerDetails.trailerAxles = trailerAxles;
    }
}

class VehicleCurrentMaxTrainWeight {
    late int value;
    VehicleCurrentMaxTrainWeight(int val): value = val;
}

class ActualNumberOfPassengers {
    late int value;
    ActualNumberOfPassengers(int val): value = val;
}

class AxleWeightLimits {
    late int maxLadenweightOnAxle1;
    late int maxLadenweightOnAxle2;
    late int maxLadenweightOnAxle3;
    late int maxLadenweightOnAxle4;
    late int maxLadenweightOnAxle5;
    AxleWeightLimits.fromC(C.AxleWeightLimits c_obj):
        maxLadenweightOnAxle1 = c_obj.maxLadenweightOnAxle1,
        maxLadenweightOnAxle2 = c_obj.maxLadenweightOnAxle2,
        maxLadenweightOnAxle3 = c_obj.maxLadenweightOnAxle3,
        maxLadenweightOnAxle4 = c_obj.maxLadenweightOnAxle4,
        maxLadenweightOnAxle5 = c_obj.maxLadenweightOnAxle5;

    void toC(Pointer<C.AxleWeightLimits> pointer) {
        final c_axleWeights = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_axleWeights.maxLadenweightOnAxle1 = maxLadenweightOnAxle1;
        c_axleWeights.maxLadenweightOnAxle2 = maxLadenweightOnAxle2;
        c_axleWeights.maxLadenweightOnAxle3 = maxLadenweightOnAxle3;
        c_axleWeights.maxLadenweightOnAxle4 = maxLadenweightOnAxle4;
        c_axleWeights.maxLadenweightOnAxle5 = maxLadenweightOnAxle5;
    }
}

class DieselEmissionValues {
    late Particulate particulate;
    late int absorptionCoeff;
    DieselEmissionValues.fromC(C.DieselEmissionValues c_obj){
        particulate = Particulate.fromC(c_obj.particulate);
        absorptionCoeff = c_obj.absorptionCoeff;
    }

    void toC(Pointer<C.DieselEmissionValues> pointer) {
        final c_dieselEmissions = pointer.ref;
        
        // Handle particulate (embedded struct)
        particulate.toC(Pointer.fromAddress(
            pointer.address // particulate is likely the first field
        ));
        
        // Handle absorptionCoeff (direct int field)
        c_dieselEmissions.absorptionCoeff = absorptionCoeff;
    }
}

class Particulate {
    late int unitType;
    late int value;
    Particulate.fromC(C.Particulate c_obj) {
        unitType = c_obj.unitType;
        value = c_obj.value;
    }

    void toC(Pointer<C.Particulate> pointer) {
        final c_particulate = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_particulate.unitType = unitType;
        c_particulate.value = value;
    }
}

class DriverCharacteristics {
    late int driverClass;
    late int tripPurpose;
    DriverCharacteristics.fromC(C.DriverCharacteristics c_obj) {
        driverClass = c_obj.driverClass;
        tripPurpose = c_obj.tripPurpose;
    }

    void toC(Pointer<C.DriverCharacteristics> pointer) {
        final c_driverChar = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_driverChar.driverClass = driverClass;
        c_driverChar.tripPurpose = tripPurpose;
    }
}

class EngineDetails {
    late int engineCapacity;
    late int enginePower;
    EngineDetails.fromC(C.EngineDetails c_obj):
        engineCapacity = c_obj.engineCapacity,
        enginePower = c_obj.enginePower;
    void toC(Pointer<C.EngineDetails> pointer) {
        final c_engineDetails = pointer.ref;

        // These are direct struct fields (not pointers), so assign directly
        c_engineDetails.engineCapacity = engineCapacity;
        c_engineDetails.enginePower = enginePower;
    }
}

class ExhaustEmissionValues {
    late int unitType;
    late int emissionCo;
    late int emissionHc;
    late int emissionNox;
    late int emissionHcNox;
    ExhaustEmissionValues.fromC(C.ExhaustEmissionValues c_obj) {
        unitType = c_obj.unitType;
        emissionCo = c_obj.emissionCo;
        emissionHc = c_obj.emissionHc;
        emissionNox = c_obj.emissionNox;
        emissionHcNox = c_obj.emissionHcNox;
    }

    void toC(Pointer<C.ExhaustEmissionValues> pointer) {
        final c_exhaustEmissions = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_exhaustEmissions.unitType = unitType;
        c_exhaustEmissions.emissionCo = emissionCo;
        c_exhaustEmissions.emissionHc = emissionHc;
        c_exhaustEmissions.emissionNox = emissionNox;
        c_exhaustEmissions.emissionHcNox = emissionHcNox;
    }
}

class PassengerCapacity {
    late int numberOfSeats;
    late int numberOfStandingPlaces;
    PassengerCapacity.fromC(C.PassengerCapacity c_obj) {
        numberOfSeats = c_obj.numberOfSeats;
        numberOfStandingPlaces = c_obj.numberOfStandingPlaces;
    }

    void toC(Pointer<C.PassengerCapacity> pointer) {
        final c_passengerCap = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_passengerCap.numberOfSeats = numberOfSeats;
        c_passengerCap.numberOfStandingPlaces = numberOfStandingPlaces;
    }
}

class SoundLevel {
    late int soundStationary;
    late int soundDriveBy;
    SoundLevel.fromC(C.SoundLevel c_obj) {
        soundStationary = c_obj.soundStationary;
        soundDriveBy = c_obj.soundDriveBy;
    }

    void toC(Pointer<C.SoundLevel> pointer) {
        final c_soundLevel = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_soundLevel.soundStationary = soundStationary;
        c_soundLevel.soundDriveBy = soundDriveBy;
    }
}






