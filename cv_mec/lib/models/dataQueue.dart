import 'dart:async';
import 'dart:io';

class DataQueue {
  final _queue = StreamController<String>();
  late File _file;
  Future<void>? _lastWriteOperation;

  DataQueue(File file) {
    _file = file;

    _queue.stream.listen((item) async {
      _lastWriteOperation = _writeDataToFile("$item", _lastWriteOperation);
      });
  }

  void addItem(String item) {
    _queue.sink.add(item);
  }

  Future<void> _writeDataToFile(String data, Future<void>? awaitCondition) async {
    if(awaitCondition != null){
      await awaitCondition;
    }
    await _file.writeAsString(data, mode: FileMode.append);
  }

  void dispose() {
    _queue.close();
  }
}