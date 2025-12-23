import 'dart:async';
import 'dart:io';

import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/itis/itis_sequence.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';

class VehicleNotificationManager {
  static const platform = MethodChannel('com.neaera.cv_mec/vehicle-notification');

  static SettingsController settingsController = Get.find<SettingsController>();

  static Future<String> _convertImageProviderToBase64(ImageProvider imageProvider) async {
    // Load the image
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );
    stream.addListener(listener);
    final ui.Image image = await completer.future;
    stream.removeListener(listener);

    // Convert the image to bytes
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = byteData!.buffer.asUint8List();

    // Encode the bytes to a base64 string
    final String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  static Future<void> _sendNotificationCommand(int id, String message, String? imageB64) async {
    if (!settingsController.notificationsEnabled.value) {
      return;
    }
    platform.invokeMethod<int>('notify', <String, dynamic>{
      'id': id,
      'description': message,
      'image_b64': imageB64,
    });
  }

  static Future<void> notifyVehicleFromItisSequence(ItisSequence sequence) async {
      String imageB64String = await _convertImageProviderToBase64(sequence.image);
      int id = DateTime.now().millisecondsSinceEpoch;
      _sendNotificationCommand(id, sequence.description, imageB64String);
  }

  static Future<void> notifyVehicleFromDescriptionImage(String description, ImageProvider image) async {
    String imageB64String = await _convertImageProviderToBase64(image);
    int id = DateTime.now().millisecondsSinceEpoch;
    _sendNotificationCommand(id, description, imageB64String);
  }

  static Future<void> notifyVehicleFromMessageAndImage(String message, ImageProvider<Object> image) async {
    String imageB64String = await _convertImageProviderToBase64(image);
    int id = DateTime.now().millisecondsSinceEpoch;
    _sendNotificationCommand(id, message, imageB64String);
  }

  static Future<void> notifyVehicleFromMessage(String message) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    _sendNotificationCommand(id, message, null);
  }

  static void sendPaymentMessage(String title, {String? description}) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: false,
      dragToClose: true,
      icon: const Icon(Icons.monetization_on),
    );
  }

  static void requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      }
    }
    return;
  }
}
