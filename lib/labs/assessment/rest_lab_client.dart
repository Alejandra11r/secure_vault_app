import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Ejercicio REST opcional, separado de la inyección y del uso de la bóveda.
class RestLabClient {
  RestLabClient({required Uri baseUri, http.Client? client})
      : _baseUri = _validateBaseUri(baseUri),
        _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;
  static const _timeout = Duration(seconds: 8);

  Future<List<Map<String, Object?>>> fetchItems() async {
    final response =
        await _client.get(_baseUri.resolve('items')).timeout(_timeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RestLabException(
        'La petición GET falló con HTTP ${response.statusCode}.',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List || decoded.any((item) => item is! Map)) {
      throw const RestLabException(
        'La respuesta no es una lista de objetos JSON.',
      );
    }
    return decoded
        .map((item) => (item as Map).cast<String, Object?>())
        .toList(growable: false);
  }

  void close() => _client.close();

  static Uri _validateBaseUri(Uri uri) {
    if ((uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw ArgumentError.value(
        uri,
        'baseUri',
        'Se esperaba una URI HTTP(S).',
      );
    }
    return uri.replace(
        path: uri.path.endsWith('/') ? uri.path : '${uri.path}/',);
  }
}

class RestLabException implements Exception {
  const RestLabException(this.message);
  final String message;
  @override
  String toString() => message;
}
