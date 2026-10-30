import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/workers/data_worker.dart';

void main() {
  late DataWorker worker;
  setUp(() => worker = DataWorker());
  tearDown(() => worker.dispose());

  test('procesa JSON intensivo fuera del isolate principal', () async {
    expect(
        await worker.processJson('["secure", "vault"]'), ['SECURE', 'VAULT'],);
  });

  test('informa entradas mal formadas sin quedar bloqueado', () async {
    await expectLater(worker.processJson('{bad json'), throwsFormatException);
    expect(await worker.processJson('["still works"]'), ['STILL WORKS']);
  });

  test('rechaza el uso después de cerrar el worker', () async {
    worker.dispose();
    await expectLater(worker.processJson('[]'), throwsStateError);
  });
}
