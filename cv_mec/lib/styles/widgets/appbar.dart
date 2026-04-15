import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/pages/dev_page.dart';
import 'package:cv_mec/pages/home_page.dart';
import 'package:cv_mec/pages/map_page.dart';
import 'package:cv_mec/pages/settings_page.dart';
import 'package:cv_mec/styles/app_colors.dart';
import 'package:cv_mec/styles/theme_setting.dart';
import 'package:cv_mec/styles/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CVMecAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  CVMecAppBar({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title != null ? title! : "V2X Mobile App", style: TextStyle(color: isDark(Theme.of(context).colorScheme.secondary) ? darkTextPrimaryColor : textPrimaryColor)),
      actions: <Widget>[
        navigationMenu(context),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

Widget navigationMenu(BuildContext context) {
  SettingsController settingsController = Get.find<SettingsController>();
  List<String> menuNoDev = ['Home', 'Map', 'Settings'];
  List<String> menuDev = ['Home', 'Map', 'Settings', 'Developer Page'];
  return PopupMenuButton<String>(
    icon: Icon(Icons.menu, color: isDark(Theme.of(context).colorScheme.secondary) ? darkTextPrimaryColor : textPrimaryColor), 
    color: Theme.of(context).colorScheme.secondary,
    itemBuilder: (BuildContext context) {
      return settingsController.developerMode.value
          ? menuDev.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice, style: TextStyle(color: isDark(Theme.of(context).colorScheme.secondary) ? darkTextPrimaryColor : textPrimaryColor)),
              );
            }).toList()
          : menuNoDev.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice, style: TextStyle(color: isDark(Theme.of(context).colorScheme.secondary) ? darkTextPrimaryColor : textPrimaryColor)),
              );
            }).toList();
    },
    onSelected: (String choice) {
      if (choice == 'Settings') {
        Get.to(() => SettingsPage());
      } else if (choice == 'Home') {
        Get.off(() => const HomePage());
      } else if (choice == 'Map') {
        Get.to(() => const MapPage());
      } else if (choice == 'Developer Page') {
        Get.to(() => const DevPage());
      }
    },
  );
}
