import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/modules/vault/data/datasources/vault_local_data_source.dart';
import 'package:secure_vault_app/modules/vault/data/database/vault_database.dart';
import 'package:secure_vault_app/modules/vault/data/repositories/vault_repository_impl.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/add_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/delete_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/get_notes_use_case.dart';
import 'package:secure_vault_app/modules/vault/presentation/provider/vault_provider.dart';

void main() {
  test('crea, descifra y elimina una nota de la cuenta activa', () async {
    final database = VaultDatabase.forTesting(NativeDatabase.memory());
    final repository = VaultRepositoryImpl(
      VaultLocalDataSource(database, EncryptionService()),
    );
    final provider = VaultProvider(
      addNote: AddNoteUseCase(repository),
      getNotesUseCase: GetNotesUseCase(repository),
      deleteNote: DeleteNoteUseCase(repository),
      repository: repository,
    );
    final key = List<int>.generate(32, (index) => index);

    provider.activateAccount('account-1');
    await provider.addNew('account-1', key, 'nota de prueba');
    expect(provider.notes, hasLength(1));
    expect(
      await provider.decrypt('account-1', key, provider.notes.single),
      'nota de prueba',
    );
    await provider.remove('account-1', provider.notes.single['id']!);
    expect(provider.notes, isEmpty);
    await database.close();
  });
}
