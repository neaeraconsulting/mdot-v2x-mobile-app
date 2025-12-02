

import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';

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
}

class EnvironmentalCharacteristics {
    late int euroValue;
    late int copValue;
    EnvironmentalCharacteristics.fromC(C.EnvironmentalCharacteristics c_obj):
        euroValue = c_obj.euroValue,
        copValue = c_obj.copValue;
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
}

class TrailerDetails {
    late int trailerType;
    late int trailerAxles;
    TrailerDetails.fromC(C.TrailerDetails c_obj):
        trailerType = c_obj.trailerType,
        trailerAxles = c_obj.trailerAxles;
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
}

class DieselEmissionValues {
    late Particulate particulate;
    late int absorptionCoeff;
    DieselEmissionValues.fromC(C.DieselEmissionValues c_obj){
        particulate = Particulate.fromC(c_obj.particulate);
        absorptionCoeff = c_obj.absorptionCoeff;
    }
}

class Particulate {
    late int unitType;
    late int value;
    Particulate.fromC(C.Particulate c_obj) {
        unitType = c_obj.unitType;
        value = c_obj.value;
    }
}

class DriverCharacteristics {
    late int driverClass;
    late int tripPurpose;
    DriverCharacteristics.fromC(C.DriverCharacteristics c_obj) {
        driverClass = c_obj.driverClass;
        tripPurpose = c_obj.tripPurpose;
    }
}

class EngineDetails {
    late int engineCapacity;
    late int enginePower;
    EngineDetails.fromC(C.EngineDetails c_obj):
        engineCapacity = c_obj.engineCapacity,
        enginePower = c_obj.enginePower;
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
}

class PassengerCapacity {
    late int numberOfSeats;
    late int numberOfStandingPlaces;
    PassengerCapacity.fromC(C.PassengerCapacity c_obj) {
        numberOfSeats = c_obj.numberOfSeats;
        numberOfStandingPlaces = c_obj.numberOfStandingPlaces;
    }
}

class SoundLevel {
    late int soundStationary;
    late int soundDriveBy;
    SoundLevel.fromC(C.SoundLevel c_obj) {
        soundStationary = c_obj.soundStationary;
        soundDriveBy = c_obj.soundDriveBy;
    }
}






