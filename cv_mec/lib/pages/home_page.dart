import 'package:cv_mec/pages/mqtt_page.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:cv_mec/services/timing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cv_mec/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    const String appTitle = "CV-MEC";
    Get.put(LocationService());
    Get.put(Timing());
    Get.put(SettingsController());
    Get.put(ParamController());
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.traffic),
          title: const Text(appTitle),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Get.to(() => SettingsPage());
                }),
          ],
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => const MQTTTesting());
              },
              child: const Text('MQTT Testing'),
            ),
          ],
        )));
  }
}
