import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:secure_vault_app/labs/assessment/rest_lab_client.dart';

void main() {
  test('El laboratorio REST interpreta una lista JSON recibida por HTTP', () async {
    final client = RestLabClient(
      baseUri: Uri.parse('https://example.test/api/'),
      client: MockClient((request) async {
        expect(request.url.path, '/api/items');
        return http.Response('[{"id":1}]', 200);
      }),
    );
    expect(await client.fetchItems(), [
      {'id': 1},
    ]);
    client.close();
  });

  test('El laboratorio REST rechaza respuestas fallidas y esquemas URI inválidos',
      () async {
    final client = RestLabClient(
      baseUri: Uri.parse('https://example.test/'),
      client: MockClient((_) async => http.Response('unavailable', 503)),
    );
    await expectLater(client.fetchItems(), throwsA(isA<RestLabException>()));
    client.close();
    expect(() => RestLabClient(baseUri: Uri.parse('ftp://example.test/')),
        throwsArgumentError,);
  });
}
