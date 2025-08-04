import 'dart:io';

import 'package:cv_mec/pages/load.dart';
import 'package:cv_mec/services/gpsd_service.dart';
import 'package:cv_mec/services/vehicle_notification_manager.dart';
import 'package:cv_mec/styles/theme_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:toastification/toastification.dart';
import 'package:cv_mec/controllers/configuration_controller.dart';
import 'package:cv_mec/controllers/obd_controller.dart';
import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/services/api_service.dart';
import 'package:cv_mec/services/asn_service.dart';
import 'package:cv_mec/services/aws_service.dart';
import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/geometry_service.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/mqtt_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:cv_mec/services/remote_gps.dart';
import 'package:cv_mec/services/timing.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  if (Platform.isAndroid || Platform.isIOS) {
    VehicleNotificationManager.requestPermissions();
  }

  Get.put(LocationService());
  Get.put(Timing());
  Get.put(FileService());
  Get.put(SettingsController());
  Get.put(ConfigurationController());
  Get.put(ParamController());
  Get.put(GeometryService());
  Get.put(MqttService(), tag: MqttService.etxTag);
  Get.put(MqttService(), tag: MqttService.pc5Tag);
  Get.put(ASNService());
  Get.put(ApiService());
  Get.put(RemoteGPSService());
  Get.put(GPSDService());
  Get.put(OBDController());
  Get.put(S3Service());

  runApp(
    Platform.isAndroid || Platform.isIOS
        ? NativeDeviceOrientationReader(builder: (context) => const MainApp())
        : const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'CV-MEC',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const Load(),
      ),
    );
  }
}
