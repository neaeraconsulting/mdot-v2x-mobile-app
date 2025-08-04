import 'dart:io';
import 'package:archive/archive.dart';
import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:cv_mec/controllers/settings_controller.dart';
import 'package:cv_mec/models/data_queue.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

class S3Service extends GetxService {
  final SettingsController settings = Get.find<SettingsController>();

  Future<bool> uploadFile(String filePath, String directory) async {
    final bucket = settings.s3BucketName.value;
    if (bucket.isEmpty) return false;

    final original = File(filePath);
    if (!await original.exists()) return false;

    // Compress
    final uploadDir = path.join(path.dirname(filePath), 'upload');
    await Directory(uploadDir).create(recursive: true);
    final gzPath = path.join(uploadDir, '${path.basename(filePath)}.gz');
    final bytes = await original.readAsBytes();
    final gzBytes = GZipEncoder().encode(bytes)!;
    final gzFile = await File(gzPath).writeAsBytes(gzBytes);

    try {
      final String result = await AwsS3.uploadFile(
        accessKey:   settings.s3AccessKey.value,
        secretKey:   settings.s3SecretKey.value,
        bucket:      settings.s3BucketName.value,
        region:      settings.s3Region.value,
        file:        gzFile,
        destDir:     '${settings.s3DestDir.value}/$directory',
        filename:    path.basename(gzFile.path),
        contentType: 'application/gzip',
      );

      final code = int.tryParse(result);
      return true;
    } catch (e) {
      return false;
    }
  }
}
