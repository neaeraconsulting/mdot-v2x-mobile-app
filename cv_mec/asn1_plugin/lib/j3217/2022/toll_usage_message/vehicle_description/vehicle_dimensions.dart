import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

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

        c_dimensions.vehicleLengthOverall = vehicleLengthOverall;
        c_dimensions.vehicleHeigthOverall = vehicleHeigthOverall;
        c_dimensions.vehicleWidthOverall = vehicleWidthOverall;
    }

    void free(Pointer<C.VehicleDimensions> pointer) {
        calloc.free(pointer);
    }
}