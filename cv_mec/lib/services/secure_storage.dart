//import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyBaseURI = 'baseuri';
  static const _keyVendorID = 'vendorid';
  static const _keyVzMode = "vzMode";

  static final _startUsername = dotenv.env['USERNAME']!;
  static final _startPassword = dotenv.env['PASSWORD']!;
  static final _startBaseURI = dotenv.env['API_ENDPOINT']!;
  static final _startVendorID = dotenv.env['VENDOR_ID']!;

  Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername) ?? Future.value(_startUsername);
  Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword) ?? Future.value(_startPassword);
  Future<String> getBaseURI() async =>
      await _storage.read(key: _keyBaseURI) ?? Future.value(_startBaseURI);
  Future<String> getVendorID() async =>
      await _storage.read(key: _keyVendorID) ?? Future.value(_startVendorID);
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
