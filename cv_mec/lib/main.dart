import 'package:cv_mec/models/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:cv_mec/pages/home_page.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(NativeDeviceOrientationReader(
    builder: (context) => const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AMP',
      theme: appThemeData,
      darkTheme: darkAppThemeData,
      home: const HomePage(),
    );
  }
}
