import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:conversion/conversion.dart';

typedef OBDCallback = void Function(String rawResponse);

class OBDController extends GetxController {
  final _bluetoothClassicPlugin = BluetoothClassic();
  RxList<Device> devices = <Device>[].obs;

  RxBool bluetoothInitialized = false.obs;

  final Set<Device> _scanResults = {};

  RxBool isConnected = false.obs;

  final Map<String, OBDCallback> _obdWatchers = {};

  String _inputBuffer = '';

  RxDouble speed = 0.0.obs;
  RxDouble rpm = 0.0.obs;
  RxString vin = ''.obs;
  Rx<Map<String, String>?> vehicleInfo = Rx<Map<String, String>?>(null);

  RxBool collectingVin = true.obs;
  RxBool vinCollected = false.obs;
  List<String> _vinBuffer = [];

  Timer? _obdTimer;

  final String obdSpeedCommand = '010D'; // OBD-II command for vehicle speed
  final String obdRpmCommand = '010C'; // OBD-II command for RPM
  final String obdVinCommand = '0902'; // OBD-II command for VIN

  final String obdSpeedWatchCommand = '0D'; // OBD-II command for speed
  final String obdRpmWatchCommand = '0C'; // OBD-II command for RPM

  final String obdSpeedFilterCommand = '41 0D'; // OBD-II response filter for speed
  final String obdRpmFilterCommand = '41 0C'; // OBD-II response filter for RPM

  final Convert convert = Convert();

  final String serviceUUID = "00001101-0000-1000-8000-00805f9b34fb";

  Future<void> initialize() async {
    await _bluetoothClassicPlugin.initPermissions();
    _bluetoothClassicPlugin.onDeviceDiscovered().listen((device) {
      if (!_scanResults.contains(device)) {
        _scanResults.add(device);
        if (device.name != null && device.name != "Unknown") {
          devices.add(device);
        }
      }
    });

    _bluetoothClassicPlugin.onDeviceDataReceived().listen((Uint8List data) {
      _inputBuffer += String.fromCharCodes(data);
      // Split on both \r and \n (handles \r, \n, or \r\n)
      List<String> lines = _inputBuffer.split(RegExp(r'[\r\n]+'));
      // The last element may be incomplete, so keep it in the buffer
      _inputBuffer = lines.removeLast();

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        _handleOBDResponse(line);
        if (collectingVin.value) {
          _vinBuffer.add(line);
        }
      }
    });
    bluetoothInitialized.value = true;
  }

  void scanDevices() async {
    devices.clear();
    _scanResults.clear();
    await _bluetoothClassicPlugin.startScan();
  }

  Future<void> stopScan() async {
    await _bluetoothClassicPlugin.stopScan();
  }

  Future<void> connectToDevice(String deviceAddress) async {
    try {
      isConnected.value = await _bluetoothClassicPlugin.connect(deviceAddress, serviceUUID);
      debugPrint("OBD Connected to $deviceAddress");
    } catch (e) {
      debugPrint("OBD Failed to connect: $e");
      isConnected.value = false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _bluetoothClassicPlugin.disconnect();
      _obdTimer?.cancel();
      isConnected.value = false;
      vinCollected.value = false;
      debugPrint("OBD Disconnected");
    } catch (e) {
      debugPrint("OBD Failed to disconnect: $e");
    }
  }

  Future<void> startGettingData() async {
    try {
      vin.value = await getVinOnce() ?? '';
      setupOBDWatchers();
      int obdTick = 0;
      final List<String> obdCommandList = [obdSpeedCommand, obdRpmCommand];
      _obdTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        _sendOBDCommand(obdCommandList[obdTick]);
        obdTick++;
        if (obdTick == obdCommandList.length) {
          obdTick = 0; // Reset after sending all commands
        }
      });
    } catch (e) {
      debugPrint("Failed to get data: $e");
    }
  }

  void watchOBDCommand(String command, OBDCallback callback) {
    _obdWatchers[command] = callback;
  }

  void _sendOBDCommand(String command) async {
    // OBD-II commands are usually sent as ASCII with \r
    final cmd = '$command\r';
    if (!isConnected.value) {
      debugPrint("Not connected to OBD-II device");
      return;
    }
    await _bluetoothClassicPlugin.write(cmd);
  }

  void _handleOBDResponse(String response) {
    _obdWatchers.forEach((command, callback) {
      if (response.contains(command)) {
        callback(response);
      }
    });
  }

  void setupOBDWatchers() {
    watchOBDCommand(obdSpeedWatchCommand, (resp) {
      // Parse speed from response and update observable
      if (resp.contains(obdSpeedFilterCommand)) {
        String hexSpeed = resp.replaceAll(obdSpeedFilterCommand, '').replaceAll('>', '').trim();
        if (hexSpeed.isNotEmpty) {
          List<int> speedKmh = convert.hexToDecimal(hexString: [hexSpeed]);
          double speedMph = speedKmh[0] * 0.621371;
          speed.value = speedMph;
        }
      }
    });
    watchOBDCommand(obdRpmWatchCommand, (resp) {
      // Parse RPM from response and update observable
      if (resp.contains(obdRpmFilterCommand)) {
        String hexRpm = resp.replaceAll(obdRpmFilterCommand, '').replaceAll(' ', '').trim();
        if (hexRpm.length >= 4) {
          // Extract the first two bytes (4 hex characters)
          final match = RegExp(r'^([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})').firstMatch(hexRpm);
          if (match != null) {
            final a = match.group(1)!;
            final b = match.group(2)!;
            List<int> rpmValue = convert.hexToDecimal(hexString: [a, b]);
            rpm.value = (rpmValue[0] * 256 + rpmValue[1]) / 4;
          }
        } else {
          debugPrint("Invalid RPM response: $hexRpm");
        }
      }
    });
  }

  Future<String?> getVinOnce() async {
    _vinBuffer = [];
    collectingVin = true.obs;

    _sendOBDCommand(obdVinCommand);
    await Future.delayed(const Duration(seconds: 4));
    collectingVin.value = false;

    // Extract only the hex bytes after the colon or after the header
    final hexParts = <String>[];
    for (var line in _vinBuffer) {
      final match = RegExp(r'^\d+:\s*([0-9A-F ]+)$').firstMatch(line);
      if (match != null) {
        hexParts.add(match.group(1)!);
      }
    }

    if (hexParts.isEmpty) {
      return null;
    }

    final hexString = hexParts.join(' ').replaceAll(RegExp(r'[^0-9A-F ]'), '');
    final hexList = hexString.split(' ').where((s) => s.isNotEmpty).toList();
    final bytes = convert.hexToDecimal(hexString: hexList);
    final vin = String.fromCharCodes(bytes).replaceAll(RegExp(r'[^A-Z0-9]'), '').trim().substring(1);
    vehicleInfo.value = await decodeVin(vin);
    vinCollected.value = true;
    return vin.isNotEmpty ? vin.substring(1) : null;
  }

  Future<Map<String, String>?> decodeVin(String vin) async {
    final url = 'https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin/$vin?format=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final results = decoded['Results'] as List<dynamic>;
      final summary = <String, String>{};
      for (var item in results) {
        switch (item['Variable']) {
          case 'Make':
            summary['Make'] = item['Value'] ?? '';
            break;
          case 'Model':
            summary['Model'] = item['Value'] ?? '';
            break;
          case 'Model Year':
            summary['Year'] = item['Value'] ?? '';
            break;
          case 'Vehicle Type':
            summary['Type'] = item['Value'] ?? '';
            break;
        }
      }
      return summary;
    }
    return null;
  }
}
