import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cv_mec/services/secure_storage.dart';
import 'package:cv_mec/services/shared_pref.dart';

import 'package:flutter/scheduler.dart';
import 'dart:io';

enum GPSType {
  obu,
  cradle,
  mobile,
  path,
}

class SettingsController extends GetxController {
  SettingsController();
  SharedPrefs sharedPrefs = SharedPrefs();
  final SecureStorage secureStorage = SecureStorage();

  Rx<bool> darkModeState = Get.isDarkMode.obs;
  Rx<bool> developerMode = false.obs;
  Rx<bool> soundEffectsEnabled = true.obs;

  RxString username = dotenv.env['USERNAME']!.obs;
  RxString password = dotenv.env['PASSWORD']!.obs;
  RxString baseUri = dotenv.env['API_ENDPOINT']!.obs;
  RxString pc5BrokerUrl = (dotenv.env['PC5_MQTT_BROKER'] ?? "").obs;
  RxString issScmsToken = (dotenv.env['ISS_SCMS_TOKEN'] ?? "").obs;
  RxString cradleGPSUsername = (dotenv.env['GPS_USERNAME'] ?? "").obs;
  RxString cradleGPSPassword = (dotenv.env['GPS_PASSWORD'] ?? "").obs;
  RxString cradleGPSIP = (dotenv.env['GPS_IP'] ?? "").obs;
  RxString obuIP = (dotenv.env['OBU_IP'] ?? "").obs;
  RxString pathToFollow = ''.obs;
  RxString appVersion = ''.obs;
  Rx<bool> vzMode = false.obs;
  Rx<bool> notificationsEnabled = false.obs;
  Rx<bool> demoMode = false.obs;
  Rx<bool> readMessages = false.obs;
  Rx<bool> enableIssMqtt = false.obs;
  Rx<bool> enableEtxMqtt = true.obs;
  RxInt broadcastRate = 10.obs;

  //GPS Mode
  Rx<GPSType> gpsType = GPSType.mobile.obs; // Default to mobile
  List<GPSType> gpsTypes = GPSType.values;


  // Automatically enable PC5 if the environment variable is configured
  Rx<bool> enablePC5 = dotenv.env['PC5_MQTT_BROKER'] != null ? true.obs : false.obs;

  // Automatically enable Signing if the environment variable is configured
  Rx<bool> enableIssScmsSigning = dotenv.env['ISS_SCMS_TOKEN'] != null ? true.obs : false.obs;

  RxString deviceID = ''.obs;
  RxString s3AccessKey = (dotenv.env['S3_ACCESS_KEY'] ?? "").obs;
  RxString s3SecretKey = (dotenv.env['S3_SECRET_KEY'] ?? "").obs;
  RxString s3BucketName = (dotenv.env['S3_BUCKET_NAME'] ?? "").obs;
  RxString s3Region = (dotenv.env['S3_REGION'] ?? "").obs;
  RxString s3DestDir = (dotenv.env['S3_DESTINATION'] ?? "").obs;

  initialize() async {
    username.value = await secureStorage.getUsername();
    password.value = await secureStorage.getPassword();
    baseUri.value = await secureStorage.getBaseURI();
    cradleGPSUsername.value = await secureStorage.getGPSUsername();
    cradleGPSPassword.value = await secureStorage.getGPSPassword();
    cradleGPSIP.value = await secureStorage.getGPSIP();
    obuIP.value = await secureStorage.getOBUIP();
    pathToFollow.value = await secureStorage.getPathToFollow();
    pc5BrokerUrl.value = await secureStorage.getPC5BrokerUrl();
    vzMode.value = await secureStorage.getVZMode();
    deviceID.value = await secureStorage.getDeviceID();
    notificationsEnabled.value = await secureStorage.getNotificationsEnabled();
    demoMode.value = await secureStorage.getDemoMode();
    readMessages.value = await secureStorage.getReadMessages();
    developerMode.value = await secureStorage.getDeveloperMode();
    soundEffectsEnabled.value = await secureStorage.getSoundEffectsEnabled();
    enablePC5.value = await secureStorage.getPC5Enabled();
    enableIssMqtt.value = await secureStorage.getISSMqttEnabled();
    enableEtxMqtt.value = await secureStorage.getEtxMqttEnabled();
    enableIssScmsSigning.value = await secureStorage.getIssScmsSigningEnabled();
    broadcastRate.value = await secureStorage.getBroadcastRate();

    // Configuration Parameters for AWS S3
    s3AccessKey.value = await secureStorage.getS3AccessKey();
    s3SecretKey.value = await secureStorage.getS3SecretKey();
    s3BucketName.value = await secureStorage.getS3BucketName();
    s3Region.value = await secureStorage.getS3Region();
    s3DestDir.value = await secureStorage.getS3DestDir();


    
    gpsType.value = toGPSType(await secureStorage.getGPSType());

    if (gpsType.value == GPSType.mobile && Platform.isLinux) {
      gpsType.value = GPSType.cradle;
    }

    bool? darkMode = await sharedPrefs.getDarkModeFromPrefs();
    if (darkMode != null) {
      if (darkMode) {
        Get.changeThemeMode(ThemeMode.dark);
        darkModeState.value = true;
      } else {
        Get.changeThemeMode(ThemeMode.light);
        darkModeState.value = false;
      }
    } else {
      Get.changeThemeMode(ThemeMode.system);
      bool isSystemDarkMode = SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

      darkModeState.value = isSystemDarkMode;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform(); // Fetch the app version
    appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  Future logout() async {}

  @override
  void onInit() async {
    //await initialize();
    super.onInit();
  }

  void switchModeState() async {
    darkModeState.value = !darkModeState.value;
    if (darkModeState.value) {
      Get.changeThemeMode(ThemeMode.dark);
      await sharedPrefs.saveDarkModeToPrefs(darkModeState.value);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      await sharedPrefs.saveDarkModeToPrefs(darkModeState.value);
    }
  }

  GPSType toGPSType(String type) {
    switch (type.toLowerCase()) {
      case 'obu':
        return GPSType.obu;
      case 'cradle':
        return GPSType.cradle;
      case 'mobile':
        return GPSType.mobile;
      case 'path':
        return GPSType.path;
      default:
        return GPSType.mobile; // Default to mobile if unknown
    }
  }
}
