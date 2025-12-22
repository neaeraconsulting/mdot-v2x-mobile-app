import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'package:asn1_plugin/j3217/2022/toll_usage_message/vehicle_description/trailer_details.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class TrailerCharacteristics {
    late TrailerDetails trailerDetails;
    late int trailerMaxLadenWeight;
    late int trailerWeightUnladen;
    TrailerCharacteristics.fromC(C.TrailerCharacteristics c_obj){
        trailerDetails = TrailerDetails.fromC(c_obj.trailerDetails);
        trailerMaxLadenWeight = c_obj.trailerMaxLadenWeight;
        trailerWeightUnladen = c_obj.trailerWeightUnladen;
    }

    void toC(Pointer<C.TrailerCharacteristics> pointer) {
        final c_trailerChar = pointer.ref;
        
        // Handle trailerDetails (embedded struct)
        trailerDetails.toC(Pointer.fromAddress(
            pointer.address // trailerDetails is likely the first field
        ));
        
        // Handle trailerMaxLadenWeight (direct int field)
        c_trailerChar.trailerMaxLadenWeight = trailerMaxLadenWeight;
        
        // Handle trailerWeightUnladen (direct int field)
        c_trailerChar.trailerWeightUnladen = trailerWeightUnladen;
    }

    
}