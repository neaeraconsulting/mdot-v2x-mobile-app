// asn1_plugin/src/dummy.cpp
extern "C"
{

  // the descriptor pointer your Dart FFI looks up
  void *asn_DEF_MessageFrame = nullptr;

  // a stub PER‐decode function
  // Dart doesn’t care about the signature at load time,
  // only that the symbol exists.
  void *uper_decode(...)
  {
    return nullptr;
  }

  // a stub PER‐encode function
  void *uper_encode(...)
  {
    return nullptr;
  }

  // any other symbols your FFI bindings reference:
  // e.g. asn_DEF_AnotherType, some asn_free_* functions, etc.
  // void *asn_DEF_AnotherType = nullptr;
  // void asn_free_xxx(...) {}

  // a no‐op so CMake has at least one translation unit
  void asn1_plugin_dummy() {}
}