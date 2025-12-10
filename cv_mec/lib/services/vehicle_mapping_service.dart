
import 'package:asn1_plugin/j3217/2022/toll_advertisement_message/vehicle_types.dart';
import 'package:asn1_plugin/j3217/2022/toll_usage_message/veh_weight_units.dart';

import '../models/vehicle.dart';
// import '../../asn1_plugin/lib/j3217/2022/toll_advertisement_message/vehicle_types.dart';

class VehicleMappingService {
  
  static const Map<VehicleType, VehicleSpecification> _vehicleSpecs = {
    VehicleType.PASSENGER_VEHICLE: VehicleSpecification(
      vehicleTypes: VehicleTypes.passengerCars,
      axles: 2,
      weight: 3000,
      numOccupants: 2,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 60, // inches
    ),
    VehicleType.LIGHT_TRUCK: VehicleSpecification(
      vehicleTypes: VehicleTypes.fourTireSingleUnit,
      axles: 2,
      weight: 8000,
      numOccupants: 1,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 72,
    ),
    VehicleType.TRUCK: VehicleSpecification(
      vehicleTypes: VehicleTypes.fourOrMoreAxleSingleUnit,
      axles: 3,
      weight: 20000,
      numOccupants: 1,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 120,
    ),
    VehicleType.MOTORCYCLE: VehicleSpecification(
      vehicleTypes: VehicleTypes.motorcycles,
      axles: 2,
      weight: 500,
      numOccupants: 1,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 48,
    ),
    VehicleType.BUS: VehicleSpecification(
      vehicleTypes: VehicleTypes.buses,
      axles: 2,
      weight: 15000,
      numOccupants: 10,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 108,
    ),
    VehicleType.FIRE: VehicleSpecification(
      vehicleTypes: VehicleTypes.twoAxleSixTireSingleUnit,
      axles: 3,
      weight: 20000,
      numOccupants: 2,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 120,
    ),
    VehicleType.POLICE: VehicleSpecification(
      vehicleTypes: VehicleTypes.passengerCars,
      axles: 2,
      weight: 4000,
      numOccupants: 2,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 60,
    ),
    VehicleType.AMBULANCE: VehicleSpecification(
      vehicleTypes: VehicleTypes.twoAxleSixTireSingleUnit,
      axles: 2,
      weight: 12000,
      numOccupants: 2,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 96,
    ),
    VehicleType.ICE_CREAM_TRUCK: VehicleSpecification(
      vehicleTypes: VehicleTypes.fourTireSingleUnit,
      axles: 2,
      weight: 8000,
      numOccupants: 1,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 84,
    ),
    VehicleType.OTHER: VehicleSpecification(
      vehicleTypes: VehicleTypes.passengerCars,
      axles: 2,
      weight: 3000,
      numOccupants: 1,
      defaultWeightUnit: VehWeightUnits.pounds,
      height: 60,
    ),
  };

  static VehicleSpecification getSpecification(VehicleType vehicleType) {
    return _vehicleSpecs[vehicleType] ?? _vehicleSpecs[VehicleType.PASSENGER_VEHICLE]!;
  }

  static VehicleTypes getVehicleTypes(VehicleType vehicleType) {
    return getSpecification(vehicleType).vehicleTypes;
  }

  static int getAxles(VehicleType vehicleType) {
    return getSpecification(vehicleType).axles;
  }

  static int getWeight(VehicleType vehicleType) {
    return getSpecification(vehicleType).weight;
  }

  static int getHeight(VehicleType vehicleType) {
    return getSpecification(vehicleType).height;
  }

  static int getNumOccupants(VehicleType vehicleType) {
    return getSpecification(vehicleType).numOccupants;
  }

  static VehWeightUnits getDefaultWeightUnit(VehicleType vehicleType) {
    return getSpecification(vehicleType).defaultWeightUnit;
  }
}

class VehicleSpecification {
  final VehicleTypes vehicleTypes;
  final int axles;
  final int weight;
  final int height;
  final int numOccupants;
  final VehWeightUnits defaultWeightUnit;

  const VehicleSpecification({
    required this.vehicleTypes,
    required this.axles,
    required this.weight,
    required this.height,
    required this.numOccupants,
    required this.defaultWeightUnit,
  });
}