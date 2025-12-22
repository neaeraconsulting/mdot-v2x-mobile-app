import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class AxleWeightLimits {
    late int maxLadenweightOnAxle1;
    late int maxLadenweightOnAxle2;
    late int maxLadenweightOnAxle3;
    late int maxLadenweightOnAxle4;
    late int maxLadenweightOnAxle5;
    AxleWeightLimits.fromC(C.AxleWeightLimits c_obj):
        maxLadenweightOnAxle1 = c_obj.maxLadenweightOnAxle1,
        maxLadenweightOnAxle2 = c_obj.maxLadenweightOnAxle2,
        maxLadenweightOnAxle3 = c_obj.maxLadenweightOnAxle3,
        maxLadenweightOnAxle4 = c_obj.maxLadenweightOnAxle4,
        maxLadenweightOnAxle5 = c_obj.maxLadenweightOnAxle5;

    void toC(Pointer<C.AxleWeightLimits> pointer) {
        final c_axleWeights = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_axleWeights.maxLadenweightOnAxle1 = maxLadenweightOnAxle1;
        c_axleWeights.maxLadenweightOnAxle2 = maxLadenweightOnAxle2;
        c_axleWeights.maxLadenweightOnAxle3 = maxLadenweightOnAxle3;
        c_axleWeights.maxLadenweightOnAxle4 = maxLadenweightOnAxle4;
        c_axleWeights.maxLadenweightOnAxle5 = maxLadenweightOnAxle5;
    }
}