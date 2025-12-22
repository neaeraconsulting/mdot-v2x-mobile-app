import 'package:asn1_plugin/generated_bindings.dart' as C;
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class SoundLevel {
    late int soundStationary;
    late int soundDriveBy;
    SoundLevel.fromC(C.SoundLevel c_obj) {
        soundStationary = c_obj.soundStationary;
        soundDriveBy = c_obj.soundDriveBy;
    }

    void toC(Pointer<C.SoundLevel> pointer) {
        final c_soundLevel = pointer.ref;
        
        c_soundLevel.soundStationary = soundStationary;
        c_soundLevel.soundDriveBy = soundDriveBy;
    }
}