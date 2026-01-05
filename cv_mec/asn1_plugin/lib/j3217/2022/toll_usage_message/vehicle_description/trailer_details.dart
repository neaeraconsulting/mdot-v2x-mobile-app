import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class TrailerDetails {
    late int trailerType;
    late int trailerAxles;
    TrailerDetails.fromC(C.TrailerDetails c_obj):
        trailerType = c_obj.trailerType,
        trailerAxles = c_obj.trailerAxles;
    
    void toC(Pointer<C.TrailerDetails> pointer) {
        final c_trailerDetails = pointer.ref;
        
        c_trailerDetails.trailerType = trailerType;
        c_trailerDetails.trailerAxles = trailerAxles;
    }

    void free(Pointer<C.TrailerDetails> pointer) {
        calloc.free(pointer);
    }
}