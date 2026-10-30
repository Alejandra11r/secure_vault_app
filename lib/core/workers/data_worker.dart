import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

/// Worker didáctico. No enviar claves ni contenido descifrado de la bóveda.
class DataWorker {
  final ReceivePort _readyPort = ReceivePort();
  Isolate? _isolate;
  SendPort? _sendPort;
  Future<void>? _initializing;
  bool _disposed = false;

  Future<void> init() {
    if (_sendPort != null) return Future<void>.value();
    if (_disposed) return Future.error(StateError('Worker is disposed.'));
    return _initializing ??= _start();
  }

  Future<void> _start() async {
    final ready = _readyPort.first.timeout(const Duration(seconds: 5));
    _isolate = await Isolate.spawn<SendPort>(_entryPoint, _readyPort.sendPort);
    _sendPort = await ready as SendPort;
  }

  static void _entryPoint(SendPort mainSendPort) {
    final requests = ReceivePort();
    mainSendPort.send(requests.sendPort);
    requests.listen((dynamic request) {
      if (request is! List || request.length != 2 || request[1] is! SendPort) {
        return;
      }
      final replyPort = request[1] as SendPort;
      try {
        if (request[0] is! String) {
          throw const FormatException('Expected a JSON string.');
        }
        final decoded = jsonDecode(request[0] as String);
        if (decoded is! List || decoded.any((value) => value is! String)) {
          throw const FormatException('Expected a JSON list of strings.');
        }
        replyPort.send({
          'ok': true,
          'data':
              decoded.map((value) => (value as String).toUpperCase()).toList(),
        });
      } catch (error) {
        replyPort.send({'ok': false, 'error': error.toString()});
      }
    });
  }

  Future<List<String>> processJson(String json) async {
    await init();
    final responsePort = ReceivePort();
    try {
      _sendPort!.send([json, responsePort.sendPort]);
      final result =
          await responsePort.first.timeout(const Duration(seconds: 10));
      if (result is! Map || result['ok'] != true || result['data'] is! List) {
        throw FormatException(
            'Isolate processing failed: ${result is Map ? result['error'] : 'invalid response'}',);
      }
      return List<String>.from(result['data'] as List);
    } finally {
      responsePort.close();
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _readyPort.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
  }
}
