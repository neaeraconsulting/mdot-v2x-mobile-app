import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class DriverCharacteristics {
    late int driverClass;
    late int tripPurpose;
    DriverCharacteristics.fromC(C.DriverCharacteristics c_obj) {
        driverClass = c_obj.driverClass;
        tripPurpose = c_obj.tripPurpose;
    }

    void toC(Pointer<C.DriverCharacteristics> pointer) {
        final c_driverChar = pointer.ref;
        
        c_driverChar.driverClass = driverClass;
        c_driverChar.tripPurpose = tripPurpose;
    }

    void free(Pointer<C.DriverCharacteristics> pointer) {
        calloc.free(pointer);
    }
}