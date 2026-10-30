import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/workers/data_worker.dart';

void main() {
  late DataWorker worker;
  setUp(() => worker = DataWorker());
  tearDown(() => worker.dispose());

  test('processes CPU-bound JSON work off the main isolate', () async {
    expect(
        await worker.processJson('["secure", "vault"]'), ['SECURE', 'VAULT'],);
  });

  test('returns malformed input errors instead of hanging', () async {
    await expectLater(worker.processJson('{bad json'), throwsFormatException);
    expect(await worker.processJson('["still works"]'), ['STILL WORKS']);
  });

  test('rejects use after disposal', () async {
    worker.dispose();
    await expectLater(worker.processJson('[]'), throwsStateError);
  });
}
