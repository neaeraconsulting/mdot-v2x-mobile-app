import 'package:cv_mec/services/param_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class ConfigDialogTwo extends StatelessWidget {
  ParamController controller = Get.find<ParamController>();

  TextEditingController clientTypeController = TextEditingController();
  TextEditingController clientSubtypeController = TextEditingController();
  TextEditingController messageFormatController = TextEditingController();
  TextEditingController v2xTypeController = TextEditingController();
  TextEditingController fakeLatitudeController = TextEditingController();
  TextEditingController fakeLongitudeController = TextEditingController();
  TextEditingController messageDelayController = TextEditingController();

  ConfigDialogTwo({super.key});
  TextEditingController privateDeviceIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    clientTypeController.text = controller.clientType.value;
    clientSubtypeController.text = controller.clientSubtype.value;
    messageFormatController.text = controller.messageFormat.value;
    v2xTypeController.text = controller.v2xType.value;
    fakeLatitudeController.text = controller.registrationLatitude.value.toString();
    fakeLongitudeController.text = controller.registrationLongitude.value.toString();
    messageDelayController.text = controller.messageDelay.value.toString();
    privateDeviceIDController.text = controller.privateDeviceID.value;

    return AlertDialog(
      title: const Text('Configuration'),
      content: SingleChildScrollView(
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Client Type'),
                  controller: clientTypeController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Client Subtype'),
                  controller: clientSubtypeController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Message Format'),
                  controller: messageFormatController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'V2X Type'),
                  controller: v2xTypeController,
                ),
                SwitchListTile(
                  title: controller.networkTypeToggle.value ? const Text('VZ Network') : const Text('Non-VZ Network'),
                  value: controller.networkTypeToggle.value,
                  onChanged: (value) {
                    controller.networkTypeToggle.value = value;
                  },
                ),
                SwitchListTile(
                  title: const Text('Use Fake Position'),
                  value: controller.useFakePositionToggle.value,
                  onChanged: (value) {
                    controller.useFakePositionToggle.value = value;
                  },
                ),
                controller.useFakePositionToggle.value
                    ? TextField(
                        decoration: const InputDecoration(labelText: 'Fake Latitude'),
                        controller: fakeLatitudeController,
                      )
                    : Container(),
                controller.useFakePositionToggle.value
                    ? TextField(
                        decoration: const InputDecoration(labelText: 'Fake Longitude'),
                        controller: fakeLongitudeController,
                      )
                    : Container(),
                TextField(
                  decoration: const InputDecoration(labelText: 'message delay'),
                  controller: messageDelayController,
                ),
                // Removing this to Disable Private Topics
                SwitchListTile(
                  title: const Text("Geo or Private"),
                  subtitle: controller.geoRelevanceOrPrivateToggle.value
                      ? const Text('Private')
                      : const Text('Geo Relevance'),
                  value: controller.geoRelevanceOrPrivateToggle.value,
                  onChanged: (value) {
                    controller.geoRelevanceOrPrivateToggle.value = value;
                  },
                ),
                controller.geoRelevanceOrPrivateToggle.value
                    ? TextField(
                        decoration: const InputDecoration(labelText: 'Private Device ID'),
                        controller: privateDeviceIDController,
                      )
                    : Container(),
              ],
            )),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Load the default configuration
            controller.loadDefaults();
            clientTypeController.text = controller.clientType.value;
            clientSubtypeController.text = controller.clientSubtype.value;
            messageFormatController.text = controller.messageFormat.value;
            v2xTypeController.text = controller.v2xType.value;
            fakeLatitudeController.text = controller.registrationLatitude.value.toString();
            fakeLongitudeController.text = controller.registrationLongitude.value.toString();
            messageDelayController.text = controller.messageDelay.value.toString();
            privateDeviceIDController.text = controller.privateDeviceID.value;
            Get.back();
            Get.dialog(ConfigDialogTwo());
          },
          child: const Text('Load Defaults'),
        ),
        TextButton(
          onPressed: () {
            controller.useFakePositionToggle.value = controller.usingFakePosition;
            controller.networkTypeToggle.value = controller.networkType.value == "VZ";
            controller.geoRelevanceOrPrivateToggle.value = controller.geoRelevanceOrPrivate;
            Get.back(); // Close the dialog
          },
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!inputValid()) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.flatColored,
                title: const Text("One or more fields are empty"), 
                alignment: Alignment.topCenter,
                autoCloseDuration: const Duration(seconds: 5),
                showProgressBar: false,
                dragToClose: true,
              );
              return;
            } else {
              if (fakeLatitudeController.text.isEmpty) {
                fakeLatitudeController.text = '0.0';
              }
              if (fakeLongitudeController.text.isEmpty) {
                fakeLongitudeController.text = '0.0';
              }
              controller.saveParams(
                  clientType: clientTypeController.text,
                  clientSubtype: clientSubtypeController.text,
                  messageFormat: messageFormatController.text,
                  v2xType: v2xTypeController.text,
                  fakeLatitude: double.parse(fakeLatitudeController.text),
                  fakeLongitude: double.parse(fakeLongitudeController.text),
                  messageDelay: int.parse(messageDelayController.text),
                  privateDeviceID: privateDeviceIDController.text);
              // Save the configuration and close the dialog
              Get.back(); // Close the dialog
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  inputValid() {
    if (clientTypeController.text.isEmpty) {
      return false;
    }
    if (clientSubtypeController.text.isEmpty) {
      return false;
    }
    if (messageFormatController.text.isEmpty) {
      return false;
    }
    if (v2xTypeController.text.isEmpty) {
      return false;
    }
    if (controller.useFakePositionToggle.value) {
      if (fakeLatitudeController.text.isEmpty) {
        return false;
      }
      if (fakeLongitudeController.text.isEmpty) {
        return false;
      }
    }
    if (messageDelayController.text.isEmpty) {
      return false;
    }
    if (controller.geoRelevanceOrPrivateToggle.value) {
      if (privateDeviceIDController.text.isEmpty) {
        return false;
      }
    }
    return true;
  }
}
