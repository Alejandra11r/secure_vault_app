import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/modules/vault/data/datasources/vault_local_data_source.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('VaultLocalDataSource', () {
    test('save and get notes', () async {
      final storage = FakeSecureStorage();
      final dataSource = VaultLocalDataSource(storage);

      await dataSource.saveNote('0', 'hola mundo');
      final notes = await dataSource.getNotes();
      expect(notes.length, greaterThanOrEqualTo(1));
      final item = notes.first;
      expect(item.containsKey('cipher'), true);
      expect(item.containsKey('key'), true);
    });

    test('delete note', () async {
      final storage = FakeSecureStorage();
      final dataSource = VaultLocalDataSource(storage);

      await dataSource.saveNote('1', 'otra nota');
      await dataSource.deleteNote('1');
      final notes = await dataSource.getNotes();
      final found = notes.where((n) => n['id'] == '1').toList();
      expect(found.isEmpty, true);
    });
  });
}
