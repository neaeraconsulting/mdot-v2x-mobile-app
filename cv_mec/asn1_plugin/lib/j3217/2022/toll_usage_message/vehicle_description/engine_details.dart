import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class EngineDetails {
    late int engineCapacity;
    late int enginePower;
    EngineDetails.fromC(C.EngineDetails c_obj):
        engineCapacity = c_obj.engineCapacity,
        enginePower = c_obj.enginePower;
    void toC(Pointer<C.EngineDetails> pointer) {
        final c_engineDetails = pointer.ref;
        c_engineDetails.engineCapacity = engineCapacity;
        c_engineDetails.enginePower = enginePower;
    }
    void free(Pointer<C.EngineDetails> pointer) {
        calloc.free(pointer);
    }
}