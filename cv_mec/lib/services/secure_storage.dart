//import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyBaseURI = 'baseuri';
  static const _keyVendorID = 'vendorid';

  static const _startUsername = "";
  static const _startPassword = "";
  static const _startBaseURI = "";
  static const _startVendorID = "";

  Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername) ?? _startUsername;
  Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword) ?? _startPassword;
  Future<String> getBaseURI() async =>
      await _storage.read(key: _keyBaseURI) ?? _startBaseURI;
  Future<String> getVendorID() async =>
      await _storage.read(key: _keyVendorID) ?? _startVendorID;

  Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);
  Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);
  Future setBaseURI(String baseURI) async =>
      await _storage.write(key: _keyBaseURI, value: baseURI);
  Future setVendorID(String vendorID) async =>
      await _storage.write(key: _keyVendorID, value: vendorID);

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
