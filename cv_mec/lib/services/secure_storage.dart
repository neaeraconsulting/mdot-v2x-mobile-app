//import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyBaseURI = 'baseuri';
  static const _keyVendorID = 'vendorid';
  static const _keyVzMode = "vzMode";

  static const _startUsername = "user";
  static const _startPassword = "12345";
  static const _startBaseURI = "https://cvmecimpapidev2.azurewebsites.net";
  static const _startVendorID = "NeaeraEval02";

  Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername) ?? _startUsername;
  Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword) ?? _startPassword;
  Future<String> getBaseURI() async =>
      await _storage.read(key: _keyBaseURI) ?? _startBaseURI;
  Future<String> getVendorID() async =>
      await _storage.read(key: _keyVendorID) ?? _startVendorID;
  Future<bool> getVZMode() async =>
      (await _storage.read(key: _keyVzMode)) == "true";

  Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);
  Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);
  Future setBaseURI(String baseURI) async =>
      await _storage.write(key: _keyBaseURI, value: baseURI);
  Future setVendorID(String vendorID) async =>
      await _storage.write(key: _keyVendorID, value: vendorID);
  Future setVZMode(bool vzMode) async {
    if (vzMode) {
      await _storage.write(key: _keyVzMode, value: "true");
    } else {
      await _storage.write(key: _keyVzMode, value: "false");
    }
  }

  //might not need this method
  Future loadSecureStorageData() async {
    if (await _storage.read(key: _keyUsername) == null) {
      await setUsername(_startUsername);
    }
    if (await _storage.read(key: _keyPassword) == null) {
      await setPassword(_startPassword);
    }
  }

  // if adding logout functionality
  Future clear() async {
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
  }
}
