import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/add_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/delete_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/get_notes_use_case.dart';
import 'package:secure_vault_app/modules/vault/presentation/provider/vault_provider.dart';
import 'package:secure_vault_app/modules/vault/data/datasources/vault_local_data_source.dart';
import 'package:secure_vault_app/modules/vault/data/repositories/vault_repository_impl.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('VaultProvider', () {
    test('add and load notes', () async {
      final storage = FakeSecureStorage();
      final dataSource = VaultLocalDataSource(storage);
      final repo = VaultRepositoryImpl(dataSource);

      final provider = VaultProvider(
          addNote: AddNoteUseCase(repo),
          getNotesUseCase: GetNotesUseCase(repo),
          deleteNote: DeleteNoteUseCase(repo));

      await provider.addNew('nota de prueba');
      await provider.loadNotes();

      expect(provider.notes.length, greaterThanOrEqualTo(1));
    });
  });
}
