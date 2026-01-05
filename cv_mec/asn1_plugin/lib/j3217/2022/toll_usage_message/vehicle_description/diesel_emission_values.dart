import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/particulate.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class DieselEmissionValues {
    late Particulate particulate;
    late int absorptionCoeff;
    DieselEmissionValues.fromC(C.DieselEmissionValues c_obj){
        particulate = Particulate.fromC(c_obj.particulate);
        absorptionCoeff = c_obj.absorptionCoeff;
    }

    void toC(Pointer<C.DieselEmissionValues> pointer) {
        final c_dieselEmissions = pointer.ref;
        
        particulate.toC(Pointer.fromAddress(
            pointer.address 
        ));
        
        c_dieselEmissions.absorptionCoeff = absorptionCoeff;
    }

    void free(Pointer<C.DieselEmissionValues> pointer) {
        particulate.free(Pointer.fromAddress(
            pointer.address 
        ));
        
        calloc.free(pointer);
    }
}