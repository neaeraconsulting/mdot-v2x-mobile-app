import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:cv_mec/services/vehicle_notification_manager.dart';
import 'package:cv_mec/styles/app_colors.dart';
import 'package:cv_mec/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsController controller = Get.find<SettingsController>();
  ParamController paramController = Get.find<ParamController>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController baseUriController = TextEditingController();
  TextEditingController vendorIDController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  TextEditingController gpsIPController = TextEditingController();
  TextEditingController gpsUsernameController = TextEditingController();
  TextEditingController gpsPasswordController = TextEditingController();
  TextEditingController pc5BrokerUrlController = TextEditingController();
  TextEditingController registrationLatitudeController = TextEditingController();
  TextEditingController registrationLongitudeController = TextEditingController();


  FileService fileService = Get.find<FileService>();

  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    usernameController.text = controller.username.value;
    passwordController.text = controller.password.value;
    baseUriController.text = controller.baseUri.value;
    vendorIDController.text = controller.vendorID.value;
    deviceIDController.text = controller.deviceID.value;
    gpsIPController.text = controller.gpsIP.value;
    gpsUsernameController.text = controller.gpsUsername.value;
    gpsPasswordController.text = controller.gpsPassword.value;
    pc5BrokerUrlController.text = controller.pc5BrokerUrl.value;
    registrationLatitudeController.text = paramController.manualLatitude.toString();
    registrationLongitudeController.text = paramController.manualLongitude.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings Page"),
        ),
        body: Container(
            child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(children: [
              versionHeader(),
              verticalSpaceMedium,
              accountSection(),
              verticalSpaceMedium,
              configurationSection(),
              verticalSpaceMedium,
              appearanceSection(),
            ]),
          ),
        )));
  }

  versionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "App Version: ${controller.appVersion.value}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }

  accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerElement("Account", Icons.person),
        verticalSpaceSmall,
        TextField(
          decoration: const InputDecoration(labelText: 'Username'),
          controller: usernameController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.username.value) {
              controller.username.value = value;
              await controller.secureStorage.setUsername(value);
            }
          },
        ),
        verticalSpaceMedium,
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          controller: passwordController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.password.value) {
              controller.password.value = value;
              await controller.secureStorage.setPassword(value);
            }
          },
        ),
        verticalSpaceMedium,
        TextField(
          decoration: const InputDecoration(labelText: 'Base URI'),
          controller: baseUriController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.baseUri.value) {
              controller.baseUri.value = value;
              await controller.secureStorage.setBaseURI(value);
            }
          },
        ),
        verticalSpaceMedium,
        TextField(
          decoration: const InputDecoration(labelText: 'Vendor ID'),
          controller: vendorIDController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.vendorID.value) {
              controller.vendorID.value = value;
              await controller.secureStorage.setVendorID(value);
            }
          },
        ),
        verticalSpaceMedium,
        TextField(
          decoration: const InputDecoration(labelText: 'Device ID'),
          controller: deviceIDController,
          obscureText: false,
          onChanged: (value) async {
            if (value != controller.deviceID.value) {
              controller.deviceID.value = value;
              await controller.secureStorage.setDeviceID(value);
            }
          },
        ),
      ],
    );
  }

  configurationSection() {
    return Column(
      children: [
        headerElement("Configuration", Icons.settings),
        verticalSpaceMedium,
        Obx(() => Row(
          children: [
            const SizedBox(width: 14),
            const Text("GPS Mode: ", style: TextStyle(fontSize: 16)),
            Expanded(child: Container()),
            DropdownButton<GPSType>(  
              dropdownColor: Theme.of(Get.context!).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              value: controller.gpsType.value,
              items: controller.gpsTypes.map((GPSType type) {
                return DropdownMenuItem<GPSType>(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) { 
                  controller.gpsType.value = value;
                  controller.secureStorage.setGPSType(value);
                }
              },
            ),
          ],
        )),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("Enable Remote GPS"),
            value: controller.remoteGPS.value,
            onChanged: (value) async {
              if (value != controller.remoteGPS.value) {
                controller.remoteGPS.value = value;
                await controller.secureStorage.setGPSMode(value);
              }
            })),
        verticalSpaceSmall,
        Obx(() => controller.gpsType.value == GPSType.cradle
            ? Column(children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'GPS IP'),
                  controller: gpsIPController,
                  obscureText: false,
                  onChanged: (value) async {
                    if (value != controller.gpsIP.value) {
                      controller.gpsIP.value = value;
                      await controller.secureStorage.setGPSIP(value);
                    }
                  },
                ),
                verticalSpaceSmall,
                TextField(
                  decoration: const InputDecoration(labelText: 'GPS Username'),
                  controller: gpsUsernameController,
                  obscureText: true,
                  onChanged: (value) async {
                    if (value != controller.gpsUsername.value) {
                      controller.gpsUsername.value = value;
                      await controller.secureStorage.setGPSUsername(value);
                    }
                  },
                ),
                verticalSpaceSmall,
                TextField(
                  decoration: const InputDecoration(labelText: 'GPS Password'),
                  controller: gpsPasswordController,
                  obscureText: true,
                  onChanged: (value) async {
                    if (value != controller.gpsUsername.value) {
                      controller.gpsPassword.value = value;
                      await controller.secureStorage.setGPSPassword(value);
                    }
                  },
                ),
              ])
            : const SizedBox.shrink()),
        verticalSpaceSmall,
        SwitchListTile(
            title: const Text("Use PC5 MQTT Broker"),
            value: controller.enablePC5.value,
            onChanged: (value) async {
              if (value != controller.enablePC5.value) {
                controller.enablePC5.value = value;
                await controller.secureStorage.setPC5Enabled(value);
              }
            }),
        Obx(() => controller.enablePC5.value
            ? TextField(
                decoration: const InputDecoration(labelText: 'PC5 MQTT Broker URL'),
                controller: pc5BrokerUrlController,
                obscureText: true,
                onChanged: (value) async {
                  if (value != controller.pc5BrokerUrl.value) {
                    controller.pc5BrokerUrl.value = value;
                    await controller.secureStorage.setPC5BrokerUrl(value);
                  }
                },
              )
            : const SizedBox.shrink()),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("Enable Manual Registration"),
            value: paramController.manualRegistrationMode.value,
            onChanged: (value) async {
              if (value != paramController.manualRegistrationMode.value) {
                //paramController.manualRegistrationMode.value = value;
                await paramController.switchManualRegistrationMode();
                await controller.secureStorage.setManualRegistrationModeEnabled(value);
              }
            })),
        Obx(() => paramController.manualRegistrationMode.value
            ? Column(
              children: [
                TextField(
                    decoration: const InputDecoration(labelText: 'Registration Latitude'),
                    controller: registrationLatitudeController,
                    onChanged: (value) async {
                      if (value != paramController.registrationLatitude.value.toString()) {
                        paramController.manualLatitude = double.tryParse(value) ?? 0.0;
                        paramController.registrationLatitude.value = double.tryParse(value) ?? 0.0;
                        await controller.secureStorage.setRegistrationLatitude(paramController.registrationLatitude.value);
                      }
                    },
                  ),
                verticalSpaceSmall,
                TextField(
                  decoration: const InputDecoration(labelText: 'Registration Longitude'),
                  controller: registrationLongitudeController,
                  onChanged: (value) async {
                    if (value != paramController.registrationLongitude.value.toString()) {
                      paramController.manualLongitude = double.tryParse(value) ?? 0.0;
                      paramController.registrationLongitude.value = double.tryParse(value) ?? 0.0;
                      await controller.secureStorage.setRegistrationLongitude(paramController.registrationLongitude.value);
                    }
                  },
                )
              ],
            )
            : Container()),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("VZ Mode"),
            value: controller.vzMode.value,
            onChanged: (value) async {
              if (value != controller.vzMode.value) {
                controller.vzMode.value = value;
                await controller.secureStorage.setVZMode(value);
              }
            })),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("Enable Notifications"),
            value: controller.notificationsEnabled.value,
            onChanged: (value) async {
              if (value != controller.notificationsEnabled.value) {
                controller.notificationsEnabled.value = value;
                await controller.secureStorage.setNotificationsEnabled(value);
                if (controller.notificationsEnabled.value) {
                  //TODO: Fix icons
                  VehicleNotificationManager.notifyVehicleFromMessageAndImage(
                      "Notifications Enabled!", const AssetImage('assets/images/cv_mec_notification_icon.png'));
                }
              }
            })),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("Read Messages"),
            value: controller.readMessages.value,
            onChanged: (value) async {
              if (value != controller.readMessages.value) {
                controller.readMessages.value = value;
                await controller.secureStorage.setReadMessages(value);
              }
            })),
        verticalSpaceSmall,
        Obx(() => SwitchListTile(
            title: const Text("Enable Demo Mode"),
            value: controller.demoMode.value,
            onChanged: (value) async {
              if (value != controller.demoMode.value) {
                controller.demoMode.value = value;
                await controller.secureStorage.setDemoMode(value);
              }
            })),
        verticalSpaceMedium,
      ],
    );
  }

  appearanceSection() {
    return Column(
      children: [
        headerElement("Appearance", Icons.image),
        appearanceSettings(),
      ],
    );
  }

  appearanceSettings() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SwitchListTile(
                title: const Text("Dark Mode"),
                value: controller.darkModeState.value,
                onChanged: (value) {
                  controller.switchModeState();
                }),
            verticalSpaceMedium,
            SwitchListTile(
                title: const Text("Developer Mode"),
                value: controller.developerMode.value,
                onChanged: (value) async {
                  controller.developerMode.value = value;
                  await controller.secureStorage.setDeveloperMode(value);
                }),
            verticalSpaceMedium,
            SwitchListTile(
                title: const Text("Allow Sound Effects"),
                value: controller.soundEffectsEnabled.value,
                onChanged: (value) async {
                  controller.soundEffectsEnabled.value = value;
                  await controller.secureStorage.setSoundEffectsEnabled(value);
                }),
          ],
        ));
  }

  inputValid() {
    if (usernameController.text.isEmpty) {
      return false;
    }
    if (passwordController.text.isEmpty) {
      return false;
    }
    if (baseUriController.text.isEmpty) {
      return false;
    }
    if (vendorIDController.text.isEmpty) {
      return false;
    }
    return true;
  }

  headerElement(String sectionTitle, IconData icon) {
    return Column(
      children: [
        Row(children: [
          Icon(icon,
              color: controller.darkModeState.value ? lightprimaryColor : primaryColor), //change color to match theme
          const SizedBox(width: 10),
          Text(sectionTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
