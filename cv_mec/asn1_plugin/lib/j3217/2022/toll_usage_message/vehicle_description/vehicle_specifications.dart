import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/environmental_characteristics.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

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