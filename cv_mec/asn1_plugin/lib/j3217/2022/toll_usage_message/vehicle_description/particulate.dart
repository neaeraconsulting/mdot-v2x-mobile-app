import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Particulate {
    late int unitType;
    late int value;
    Particulate.fromC(C.Particulate c_obj) {
        unitType = c_obj.unitType;
        value = c_obj.value;
    }

    void toC(Pointer<C.Particulate> pointer) {
        final c_particulate = pointer.ref;
        
        c_particulate.unitType = unitType;
        c_particulate.value = value;
    }
}