import 'dart:io';
import 'package:yaml_edit/yaml_edit.dart';

void main() async {
  // Read .env file
  final envFile = File('.env');
  final envLines = await envFile.readAsLines();
  final env = <String, String>{};
  for (var line in envLines) {
    line = line.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final parts = line.split('=');
    if (parts.length == 2) {
      env[parts[0].trim()] = parts[1].trim();
    }
  }

  var logoPath = env['APP_ICON_PATH'] ?? env['LOGO_PATH'] ?? 'assets/images/Default/logo.png';
  final appName = env['APP_NAME'] ?? 'v2x_mobile_app';
  logoPath = logoPath.replaceAll('\$APP_NAME', appName);


  // Read flutter_launcher_icons.yaml
  final yamlFile = File('flutter_launcher_icons.yaml');
  final yamlContent = await yamlFile.readAsString();
  final editor = YamlEditor(yamlContent);

  // Update App Images
  editor.update(['image_path'], logoPath);
  editor.update(['flutter_launcher_icons', 'image_path'], logoPath);
  editor.update(['flutter_launcher_icons', 'web', 'image_path'], logoPath);
  editor.update(['flutter_launcher_icons', 'windows', 'image_path'], logoPath);
  editor.update(['flutter_launcher_icons', 'macos', 'image_path'], logoPath);


  // Save updated YAML
  await yamlFile.writeAsString(editor.toString());
  print('Updated flutter_launcher_icons.yaml with logo path: $logoPath');

  // Run flutter_launcher_icons
  await Process.run('dart', ['run', 'flutter_launcher_icons:main']);


  //Change app name in the strings.xml file
  final stringsFile = File('android/app/src/main/res/values/strings.xml');
  var stringsContent = await stringsFile.readAsString();
  final appNameRegex = RegExp(r'<string name="app_name">(.+?)</string>');
  stringsContent = stringsContent.replaceAllMapped(appNameRegex, (match) {
    return '<string name="app_name">$appName</string>';
  });
  await stringsFile.writeAsString(stringsContent);
  print('Updated Android app name to: $appName');


  //rewrite applicationId = "com.neaera.'something" in the build.gradle file to applicationId = "com.neaera.$appName"
  final buildFile = File('android/app/build.gradle');
  var buildContent = await buildFile.readAsString();
  final appIdRegex = RegExp(r'applicationId\s*=\s*"com\.neaera\.[^"]*"');
  //make sure appName is lowercase and replace spaces with underscores for the applicationId
  final formattedAppName = appName.toLowerCase().replaceAll(' ', '_');
  buildContent = buildContent.replaceAllMapped(appIdRegex, (match) {
    return 'applicationId = "com.neaera.$formattedAppName"';
  });
  await buildFile.writeAsString(buildContent);
  print('Updated Android applicationId to: com.neaera.$formattedAppName');

  //set the ios bundle display name by setting the CFBundleDisplayName in the Info.plist file
  final infoFile = File('ios/Runner/Info.plist');
  var infoContent = await infoFile.readAsString();
  final displayNameRegex = RegExp(r'<key>CFBundleDisplayName</key>\s*<string>(.+?)</string>');
  infoContent = infoContent.replaceAllMapped(displayNameRegex, (match) {
    return '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>';
  });
  await infoFile.writeAsString(infoContent);
  print('Updated iOS bundle display name to: $appName');

  //set the ios bundle name to formattedAppName
  final bundleNameRegex = RegExp(r'<key>CFBundleName</key>\s*<string>(.+?)</string>');
  infoContent = infoContent.replaceAllMapped(bundleNameRegex, (match) {
    return '<key>CFBundleName</key>\n\t<string>$formattedAppName</string>';
  });
  await infoFile.writeAsString(infoContent);
  print('Updated iOS bundle name to: $formattedAppName');
}