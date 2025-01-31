import 'package:cv_mec/services/file_service.dart';
import 'package:cv_mec/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:cv_mec/services/shared_pref.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  SettingsController();
  SharedPrefs sharedPrefs = SharedPrefs();
  SecureStorage secureStorage = SecureStorage();

  Rx<bool> darkModeState = Get.isDarkMode.obs;

  RxString username = dotenv.env['USERNAME']!.obs;
  RxString password = dotenv.env['PASSWORD']!.obs;
  RxString baseUri = dotenv.env['API_ENDPOINT']!.obs;
  RxString vendorID = dotenv.env['VENDOR_ID']!.obs;
  RxBool settingsChanged = false.obs;
  RxString appVersion = ''.obs;
  Rx<bool> vzMode = false.obs;
  Rx<bool> pedestrianMode = false.obs;
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
    vendorID.value = await secureStorage.getVendorID();
    vzMode.value = await secureStorage.getVZMode();
    deviceID.value = await secureStorage.getDeviceID();

    s3AccessKey.value = await secureStorage.getS3AccessKey();
    s3SecretKey.value = await secureStorage.getS3SecretKey();
    s3BucketName.value = await secureStorage.getS3BucketName();
    s3Region.value = await secureStorage.getS3Region();
    s3DestDir.value = await secureStorage.getS3DestDir();

    // pedestrianMode.value = await secureStorage.getPedestrianMode();

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
      darkModeState.value = Get.isDarkMode;
    }

    PackageInfo packageInfo =
        await PackageInfo.fromPlatform(); // Fetch the app version
    appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';
    //appVersion.value = "App Version #9";
  }

  Future logout() async {}

  @override
  void onInit() async {
    await initialize();
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
}

class SettingsPage extends StatelessWidget {
  late final SettingsController controller;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController baseUriController = TextEditingController();
  TextEditingController vendorIDController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();

  FileService fileService = Get.find<FileService>();

  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    controller = Get.find<SettingsController>();
    return FutureBuilder(
        future: controller.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          usernameController.text = controller.username.value;
          passwordController.text = controller.password.value;
          baseUriController.text = controller.baseUri.value;
          vendorIDController.text = controller.vendorID.value;
          deviceIDController.text = controller.deviceID.value;
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
                    accountSection(),
                    const SizedBox(height: 40),
                    appearanceSection(),
                  ]),
                ),
              )));
        });
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
        TextField(
          decoration: const InputDecoration(labelText: 'Username'),
          controller: usernameController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.username.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        spacer(),
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          controller: passwordController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.password.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        spacer(),
        TextField(
          decoration: const InputDecoration(labelText: 'Base URI'),
          controller: baseUriController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.baseUri.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        spacer(),
        TextField(
          decoration: const InputDecoration(labelText: 'Vendor ID'),
          controller: vendorIDController,
          obscureText: true,
          onChanged: (value) async {
            if (value != controller.vendorID.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        spacer(),
        TextField(
          decoration: const InputDecoration(labelText: 'Device ID'),
          controller: deviceIDController,
          obscureText: false,
          onChanged: (value) async {
            if (value != controller.deviceID.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        spacer(),
        SwitchListTile(
            title: const Text("VZ Mode"),
            value: controller.vzMode.value,
            onChanged: (value) {
              if (value != controller.vzMode.value) {
                controller.vzMode.value = value;
                controller.settingsChanged.value = true;
              }
            }),
        spacer(),
        Row(
          children: [
            ElevatedButton(
              onPressed: controller.settingsChanged.value
                  ? () async {
                      if (!inputValid()) {
                        Get.snackbar('Error', 'One or more fields are empty');
                        return;
                      } else {
                        controller.username.value = usernameController.text;
                        await controller.secureStorage
                            .setUsername(usernameController.text);
                        controller.password.value = passwordController.text;
                        await controller.secureStorage
                            .setPassword(passwordController.text);
                        controller.baseUri.value = baseUriController.text;
                        await controller.secureStorage
                            .setBaseURI(baseUriController.text);
                        controller.vendorID.value = vendorIDController.text;
                        await controller.secureStorage
                            .setVendorID(vendorIDController.text);
                        await controller.secureStorage
                            .setDeviceID(deviceIDController.text);
                        controller.deviceID.value = deviceIDController.text;
                        await controller.secureStorage
                            .setVZMode(controller.vzMode.value);
                        controller.settingsChanged.value = false;

                        await fileService.deleteRegistration();
                      }
                    }
                  : null,
              child: const Text("Save Changes"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.settingsChanged.value
                  ? () async {
                      usernameController.text = controller.username.value;
                      passwordController.text = controller.password.value;
                      baseUriController.text = controller.baseUri.value;
                      vendorIDController.text = controller.vendorID.value;
                      deviceIDController.text = controller.deviceID.value;

                      controller.settingsChanged.value = false;
                    }
                  : null,
              child: const Text("Undo Changes"),
            ),
          ],
        )
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
          ],
        ));
  }

  spacer() {
    return const SizedBox(height: 20);
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

  /*profileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerElement("Profile", Icons.key),
        Text('Keycloak Endpoint: ${controller.keycloakEndpoint}'),
        Text('Cimms Broker: ${controller.cimmsBroker}'),
        Text('Realm: ${controller.realm}'),
        Text('Client: ${controller.client}'),
      ],
    );
  }

  logoutButton() {
    return ElevatedButton(
      onPressed: () async {
        await controller.logout();
        // Get.to(() => LogInPage());
      },
      child: const Text('Logout'),
    );
  }*/

  headerElement(String sectionTitle, IconData icon) {
    return Column(
      children: [
        Row(children: [
          Icon(icon, color: Colors.blue), //change color to match theme
          const SizedBox(width: 10),
          Text(sectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
