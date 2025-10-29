import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/etx/full_registration.dart';
import 'package:cv_mec/models/etx/registration.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService extends GetxController {
  SettingsController settingsController = Get.find<SettingsController>();
  final Logger _logger = Logger();
  String? token;

  // static Future<ApiService> create() async {
  //   final apiService = ApiService();
  //   apiService.token = await apiService.getToken();
  //   // apiService._logger.i("API Service Initialized with Token: ${apiService.token != null}");
  //   return apiService;
  // }

  Future<bool> setupToken() async {
    token = await getToken();
    _logger.i("API Service Initialized with Token: ${token != null}");
    return token != null;
  }

  Future<String?> getToken() async {
    try {
      _logger.i("generating token from api");

      String uri = "${settingsController.baseUri.value}/auth/token";
      final Map<String, String> headers = {"Content-Type": "application/json", "Accept": "application/json"};

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
          }else{
            _logger.e("Token not found in response ${response.body.toString()}");
          }
        }else{
          _logger.e("Error Generating Token: ${response.statusCode} ${response.body.toString()}");
        }
      } catch (e) {
        _logger.e("Error Generating Token: $e");
        return null;
      }

      return null;
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    }
  }

  Future<FullRegistration?> checkRegistration(String deviceID) async {
    if(token == null){
      _logger.e("Unable to Check Registration - No API Token");
      return null;
    }
    try {
      _logger.i("Checking Device Registration");
      final String uri = "${settingsController.baseUri.value}/prd/v2/registration?DeviceID=$deviceID";
      final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};

      var response = await http.get(Uri.parse(uri), headers: headers);

      if (response.statusCode == 200) {
        dynamic registrationDynamic = jsonDecode(response.body.toString());

        FullRegistration registration = FullRegistration.fromJson(registrationDynamic);

        return registration;
      } else {
        _logger.e("Error Code ${response.statusCode} ${response.body.toString()}");
      }
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    } catch (e) {
      _logger.e("Unable to Register app for unknown reasons $e");
      return null;
    }
    return null;
  }


  Future getRegistration(String clientType, String clientSubtype) async {
    if(token == null){
      _logger.e("Unable to Complete Registration - No API Token");
      return null;
    }
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
        dynamic registrationDynamic = jsonDecode(response.body.toString());

        Registration registration = Registration.fromJson(registrationDynamic);

        return registration;
      } else {
        _logger.e(response.body.toString());
      }
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to register app with API: $e");
      return null;
    } catch (e) {
      _logger.e("Unable to Register app for unknown reasons $e");
      return null;
    }
  }

  Future updateRegistration(String deviceID) async {
    if(token == null){
      _logger.e("Unable to Update Registration - No API Token");
      return null;
    }
    try {
      _logger.i("Updating Device Registration");
      final String uri = "${settingsController.baseUri.value}/prd/v2/registration";
      final Map<String, String> headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};

      final String body = jsonEncode({
        "DeviceID": deviceID
      });

      var response = await http.put(Uri.parse(uri), headers: headers, body: body);

      if (response.statusCode == 200) {
        dynamic registrationDynamic = jsonDecode(response.body.toString());

        Registration registration = Registration.fromJson(registrationDynamic);

        return registration;
      } else if (response.statusCode == 404){
        return null;
      }else {
        _logger.e("Error Retrieving Registration ${response.statusCode} ${response.body.toString()}");
        return null;
      }
    } on SocketException catch (e) {
      _logger.e("Caught exception when attempting to update registration with API: $e");
      return null;
    } catch (e) {
      _logger.e("Unable to update registration for unknown reasons $e");
      return null;
    }
  }

  Future getConnection(String deviceID, double lat, double long, String networkType) async {
    if(token == null){
      _logger.e("Unable to Get ETX Connection - No API Token");
      return null;
    }
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

  Future<String?> getTimConfiguration() async {
    if(token == null){
      _logger.e("Unable to Get Tim Configuration - No API Token");
      return null;
    }
    try {
      _logger.i("Downloading TIM Manifest");

      String uri = "${settingsController.baseUri.value}/api/v2/tim/configuration";
      final Map<String, String> headers = {"Content-Type": "application/json", "Accept": "application/json"};

      try {
        var response = await http.get(Uri.parse(uri), headers: headers);
        if (response.statusCode == 200) {
          return response.body.toString();
        }else{
          _logger.e("Error Downloading TIM Manifest: ${response.statusCode} ${response.body.toString()}");
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

  Future<Uint8List?> getTimIcons(String version) async {
    if(token == null){
      _logger.e("Unable to get Tim Icons - No API Token");
      return null;
    }
    try {
      _logger.i("Downloading TIM Icons");

      String uri = "${settingsController.baseUri.value}/api/v2/tim/icons/$version";
      final Map<String, String> headers = {"Content-Type": "application/json", "Accept": "application/octet-stream"};

      try {
        var response = await http.get(Uri.parse(uri), headers: headers);
        if (response.statusCode == 200) {
          return response.bodyBytes;
          
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
}
