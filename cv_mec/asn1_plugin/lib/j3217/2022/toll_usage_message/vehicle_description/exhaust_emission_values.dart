import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

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
        
        c_exhaustEmissions.unitType = unitType;
        c_exhaustEmissions.emissionCo = emissionCo;
        c_exhaustEmissions.emissionHc = emissionHc;
        c_exhaustEmissions.emissionNox = emissionNox;
        c_exhaustEmissions.emissionHcNox = emissionHcNox;
    }

    void free(Pointer<C.ExhaustEmissionValues> pointer) {
        calloc.free(pointer);
    }
}