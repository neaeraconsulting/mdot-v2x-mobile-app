import 'package:cv_mec/controllers/obd_controller.dart';
import 'package:cv_mec/styles/spacing.dart';
import 'package:cv_mec/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Dialog bluetoothDialog() {
  OBDController controller = Get.find<OBDController>();
  controller.scanDevices();
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Obx(() => Padding(
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
                        await controller.stopScan();
                        Get.back(result: null);
                      },
                    ),
                    const Text("Select a Device", style: style_four),
                  ],
                ),
                verticalSpaceSmall,
                Expanded(
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
                ),
              ],
            ),
          ),
        )),
  );
}
