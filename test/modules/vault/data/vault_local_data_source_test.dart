import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/modules/vault/data/database/vault_database.dart';
import 'package:secure_vault_app/modules/vault/data/datasources/vault_local_data_source.dart';

void main() {
  group('Fuente local de bóveda Drift', () {
    late VaultDatabase database;
    late VaultLocalDataSource source;
    final key = List<int>.generate(32, (index) => index);

    setUp(() {
      database = VaultDatabase.forTesting(NativeDatabase.memory());
      source = VaultLocalDataSource(database, EncryptionService());
    });
    tearDown(() => database.close());

    test('guarda notas cifradas y aísla los registros por cuenta', () async {
      await source.saveNote(
          accountId: 'account-1',
          id: 'note-1',
          plainText: 'texto secreto',
          vaultKey: key,);
      final notes = await source.getNotes('account-1');
      expect(notes, hasLength(1));
      expect(notes.single, isNot(contains('texto secreto')));
      expect(
          await source.decryptNote(
              accountId: 'account-1', note: notes.single, vaultKey: key,),
          'texto secreto',);
      expect(await source.getNotes('account-2'), isEmpty);
    });

    test('guarda categorías, notas y archivos cifrados por cuenta',
        () async {
      await source.saveCategory(
          accountId: 'a', id: 'c', name: 'Privado', vaultKey: key,);
      final categories = await source.getCategories('a');
      expect(
          await source.decryptCategory('a', categories.single, key), 'Privado',);
      await source.saveNote(
          accountId: 'a',
          id: 'n',
          plainText: 'texto',
          vaultKey: key,
          categoryId: 'c',);
      final note = (await source.getNotes('a')).single;
      expect(
          await source.decryptNoteCategoryId(
              accountId: 'a', note: note, vaultKey: key,),
          'c',);
      await source.saveFile(
          accountId: 'a',
          id: 'f',
          name: 'secreto.txt',
          mimeType: 'text/plain',
          bytes: [104, 105],
          vaultKey: key,);
      final file = await source.getFiles('a');
      expect((await source.decryptFile('a', file.single, key))['name'],
          'secreto.txt',);
      expect(await source.getFiles('b'), isEmpty);
    });

    test('rechaza notas demasiado grandes y respeta el límite de nonces', () async {
      await expectLater(
          source.saveNote(
              accountId: 'a',
              id: 'large',
              plainText: List.filled(VaultLocalDataSource.maxNoteBytes + 1, 'x')
                  .join(),
              vaultKey: key,),
          throwsA(isA<FormatException>()),);
      await database.into(database.vaultCryptoUsage).insert(
          VaultCryptoUsageCompanion.insert(
              accountId: 'a', encryptions: const Value(1 << 20),),);
      await expectLater(
          source.saveNote(
              accountId: 'a',
              id: 'limited',
              plainText: 'blocked',
              vaultKey: key,),
          throwsA(isA<StateError>()),);
    });

    test('elimina únicamente los datos de la cuenta indicada', () async {
      await source.saveNote(
          accountId: 'a', id: 'one', plainText: 'A', vaultKey: key,);
      await source.saveNote(
          accountId: 'b', id: 'two', plainText: 'B', vaultKey: key,);
      await database.deleteAccountData('a');
      expect(await source.getNotes('a'), isEmpty);
      expect(await source.getNotes('b'), hasLength(1));
    });

    test('al eliminar una categoría conserva notas y archivos sin asignación',
        () async {
      await source.saveCategory(
          accountId: 'a', id: 'category', name: 'Work', vaultKey: key,);
      await source.saveNote(
          accountId: 'a',
          id: 'note',
          plainText: 'text',
          vaultKey: key,
          categoryId: 'category',);
      await source.saveFile(
          accountId: 'a',
          id: 'file',
          name: 'x.txt',
          mimeType: 'text/plain',
          bytes: [120],
          vaultKey: key,
          categoryId: 'category',);

      await source.deleteCategory('a', 'category', key);

      final note = (await source.getNotes('a')).single;
      expect(
          await source.decryptNoteCategoryId(
              accountId: 'a', note: note, vaultKey: key,),
          isNull,);
      final file = (await source.getFiles('a')).single;
      expect((await source.decryptFileMetadata('a', file, key))['categoryId'],
          isNull,);
      expect(await source.getCategories('a'), isEmpty);
    });
  });
}
