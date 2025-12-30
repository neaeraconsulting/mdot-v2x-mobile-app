import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class EnvironmentalCharacteristics {
    late int euroValue;
    late int copValue;
    EnvironmentalCharacteristics.fromC(C.EnvironmentalCharacteristics c_obj):
        euroValue = c_obj.euroValue,
        copValue = c_obj.copValue;
    
    void toC(Pointer<C.EnvironmentalCharacteristics> pointer) {
        final c_envChar = pointer.ref;
        
        c_envChar.euroValue = euroValue;
        c_envChar.copValue = copValue;
    }

    void free(Pointer<C.EnvironmentalCharacteristics> pointer) {
        calloc.free(pointer);
    }
}