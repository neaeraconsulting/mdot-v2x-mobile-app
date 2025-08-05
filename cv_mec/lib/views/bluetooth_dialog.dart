import 'dart:io';

import 'package:cv_mec/controllers/obd_controller.dart';
import 'package:cv_mec/styles/spacing.dart';
import 'package:cv_mec/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bluetooth_classic/models/device.dart';

Dialog bluetoothDialog() {
  OBDController controller = Get.find<OBDController>();
  if (Platform.isLinux) {
    controller.scanDevicesLinux();
  } else {
    controller.scanDevices();
  }
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 400, // Adjusted height to prevent overflow
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    if (Platform.isLinux) {
                      controller.stopBluezDevicePolling();
                    } else {
                      await controller.stopScan();
                    }
                    Get.back(result: null);
                  },
                ),
                const Text("Select a Device", style: style_four),
              ],
            ),
            verticalSpaceSmall,
            !Platform.isLinux
                ? Obx(() => Expanded(
                      child: controller.devices.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: controller.devices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(controller.devices[index].name ?? "Unknown"),
                                  onTap: () async {
                                    await controller.stopScan();
                                    Get.back(result: controller.devices[index]);
                                  },
                                );
                              },
                            ),
                    ))
                : Obx(() => Expanded(
                      child: controller.bluezDevices.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: controller.bluezDevices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(controller.bluezDevices[index].name ?? "Unknown"),
                                  onTap: () async {
                                    //await controller.stopScan();
                                    controller.stopBluezDevicePolling();
                                    Device device = Device(
                                      name: controller.bluezDevices[index].name,
                                      address: controller.bluezDevices[index].address,
                                    );
                                    Get.back(result: device);
                                  },
                                );
                              },
                            ),
                    )),
          ],
        ),
      ),
    ),
  );
}