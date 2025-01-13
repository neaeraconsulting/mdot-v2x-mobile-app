import 'dart:async';
import 'dart:io';

import 'package:cv_mec/services/file_service.dart';
import 'package:get/get.dart';

class DataQueue {
  FileService fileService = Get.find<FileService>();
  final _queue = StreamController<String>();
  late File _file;
  late String fileName;
  Future<void>? _lastWriteOperation;

  DataQueue(String fileName) {
    this.fileName = fileName;

    Future.delayed(Duration.zero, () {
      init();
    });
  }

  void init() async {
    _file = await fileService.getFileForWriting(fileName);
    _queue.stream.listen((item) async {
      _lastWriteOperation = _writeDataToFile(item, _lastWriteOperation);
    });
  }

  void addItem(String item) {
    _queue.sink.add(item);
  }

  Future<void> _writeDataToFile(
      String data, Future<void>? awaitCondition) async {
    if (awaitCondition != null) {
      await awaitCondition;
    }
    await _file.writeAsString(data, mode: FileMode.append);
  }

  void dispose() {
    _queue.close();
  }
}
