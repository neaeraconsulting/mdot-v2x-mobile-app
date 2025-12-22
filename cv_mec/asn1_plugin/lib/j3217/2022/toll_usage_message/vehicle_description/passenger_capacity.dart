import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class PassengerCapacity {
    late int numberOfSeats;
    late int numberOfStandingPlaces;
    PassengerCapacity.fromC(C.PassengerCapacity c_obj) {
        numberOfSeats = c_obj.numberOfSeats;
        numberOfStandingPlaces = c_obj.numberOfStandingPlaces;
    }

    void toC(Pointer<C.PassengerCapacity> pointer) {
        final c_passengerCap = pointer.ref;
        
        // These are direct struct fields (not pointers), so assign directly
        c_passengerCap.numberOfSeats = numberOfSeats;
        c_passengerCap.numberOfStandingPlaces = numberOfStandingPlaces;
    }
}