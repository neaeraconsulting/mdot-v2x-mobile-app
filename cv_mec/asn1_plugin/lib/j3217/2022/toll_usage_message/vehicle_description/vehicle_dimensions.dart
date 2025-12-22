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
        
        // These are direct struct fields (not pointers), so assign directly
        c_dimensions.vehicleLengthOverall = vehicleLengthOverall;
        c_dimensions.vehicleHeigthOverall = vehicleHeigthOverall;
        c_dimensions.vehicleWidthOverall = vehicleWidthOverall;
    }
}