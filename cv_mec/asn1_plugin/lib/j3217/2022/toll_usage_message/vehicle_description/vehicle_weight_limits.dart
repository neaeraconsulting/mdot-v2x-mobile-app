import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

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

    void free(Pointer<C.VehicleWeightLimits> pointer) {
        calloc.free(pointer);
    }
}