import 'dart:io';
import 'package:cv_mec/pages/home_page.dart';
import 'package:cv_mec/pages/missing_permissions.dart';
import 'package:cv_mec/services/location_service.dart';
import 'package:cv_mec/services/param_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class Load extends StatelessWidget {
  const Load({super.key});

  Future _init() async {
    LocationService locationService = Get.find<LocationService>();
    await locationService.init();
    if ((Platform.isAndroid || Platform.isIOS) && !(await locationService.isTrackingGranted() && await locationService.isPermissionGranted())) {
      Get.off(() => const MissingPermissions());
    } else {
      Get.put(ParamController(), permanent: true);
      Get.off(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                image: AssetImage(dotenv.env["LOAD_PAGE_PATH"] ?? 'assets/images/Default/load_page.png'), 
                fit: BoxFit.cover,
              ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}
