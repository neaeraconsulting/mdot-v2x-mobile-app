import 'dart:io';
import 'dart:convert';

import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/imp/registration.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService extends GetxController {
  SettingsController settingsController = Get.find<SettingsController>();
  final Logger _logger = Logger();

  Future getToken() async {
    try {
      _logger.i("generating token from api");

      String uri = "${settingsController.baseUri.value}/auth/token";
      final Map<String, String> headers = {"Content-Type": "application/json", "Accept": "application/json"};
      //SETTINGS Configuration
      final Map<String, String> body = {
        "username": settingsController.username.value,
        "password": settingsController.password.value,
      };

      try {
        var response = await http.post(Uri.parse(uri), headers: headers, body: json.encode(body));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseObject = jsonDecode(response.body.toString());
          if (responseObject.containsKey("access_token")) {
            return responseObject["access_token"];
          }
        }
      } catch (e) {
        return null;
      }

      return null;
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    }
  }

  Future getRegistration(String token, String clientType, String clientSubtype) async {
    try {
      _logger.i("Registering Device");
      final String uri = "${settingsController.baseUri.value}/prd/v2/registration";
      final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};

      final String body = jsonEncode({
        "ClientType": clientType,
        "ClientSubtype": clientSubtype,
      });

      var response = await http.post(Uri.parse(uri), headers: headers, body: body);

      if (response.statusCode == 200) {
        dynamic registrationDyanmic = jsonDecode(response.body.toString());

        Registration registration = Registration.fromJson(registrationDyanmic);

        return registration;
      } else {
        _logger.e(response.body.toString());
      }
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    } catch (e) {
      _logger.e("Unable to Register app for unknown reasons");
      return null;
    }
  }

  Future getConnection(String token, String deviceID, double lat, double long, String networkType) async {
    try {
      _logger.i("Registering Device");
      final String uri = "${settingsController.baseUri.value}/prd/v2/connection";

      final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};

      final String body = jsonEncode({"DeviceID": deviceID, "lat": lat, "long": long, "NetworkType": networkType});

      var response = await http.post(Uri.parse(uri), headers: headers, body: body);

      Map<String, dynamic> json = jsonDecode(response.body.toString());
      _logger.i(response.body.toString());
      if (json.containsKey("MqttURL")) {
        return json["MqttURL"];
      }

      return "";
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    }
  }
}
