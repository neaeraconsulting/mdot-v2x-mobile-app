import 'dart:io';

import 'generated_bindings.dart';
import 'dart:ffi';

class Asn1{

  static NativeBindings getBindings(){
    const String libName = 'asn1_plugin';

    /// The dynamic library in which the symbols for [NativeAddBindings] can be found.
    final DynamicLibrary dylib = () {
      if (Platform.isMacOS || Platform.isIOS) {
        return DynamicLibrary.open('$libName.framework/$libName');
      }
      if (Platform.isAndroid || Platform.isLinux) {
        return DynamicLibrary.open('lib$libName.so');
      }
      if (Platform.isWindows) {
        return DynamicLibrary.open('$libName.dll');
      }
      throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
    }();

    return NativeBindings(dylib);
  }
}
