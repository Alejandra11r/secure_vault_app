import 'dart:isolate';
import 'dart:convert';

class DataWorker {
  late Isolate _isolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();

  Future<void> init() async {
    _isolate = await Isolate.spawn(_entryPoint, _receivePort.sendPort);
    _sendPort = await _receivePort.first;
  }

  static void _entryPoint(SendPort mainSendPort) {
    final port = ReceivePort();
    mainSendPort.send(port.sendPort);

    port.listen(( message) {
      // ignore: avoid_dynamic_calls
      final String json = message[0] ;
      // ignore: avoid_dynamic_calls
      final SendPort replyPort = message[1];

      
      final decoded = jsonDecode(json);
      final result = (decoded as List)
          .map((e) => e.toString().toUpperCase())
          .toList();

      replyPort.send(result);
    });
  }

  Future<List<String>> processJson(String json) async {
    final responsePort = ReceivePort();

    _sendPort.send([json, responsePort.sendPort]);

    final result = await responsePort.first;
    responsePort.close();

    return List<String>.from(result);
  }

  void dispose() {
    _receivePort.close();
    _isolate.kill();
  }
}