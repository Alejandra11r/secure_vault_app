import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/modules/auth/domain/entities/auth_failure.dart';
import 'package:secure_vault_app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'package:secure_vault_app/modules/auth/data/repositories/auth_repository_impl.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('Repositorio de autenticación', () {
    late FakeSecureStorage storage;
    late AuthRepositoryImpl repository;

    setUp(() {
      storage = FakeSecureStorage();
      repository = AuthRepositoryImpl(
        AuthLocalDataSource(storage),
        EncryptionService(argonMemoryKiB: 19 * 1024),
      );
    });

    test('registra localmente y valida la contraseña al iniciar sesión', () async {
      final registered = await repository.register(
        ' User@Example.com ',
        'a strong password 123',
      );
      final loggedIn = await repository.login(
        'user@example.com',
        'a strong password 123',
      );

      expect(registered.user.email, 'user@example.com');
      expect(registered.user.accountId, loggedIn.user.accountId);
      expect(registered.vaultKey, loggedIn.vaultKey);
      expect(await repository.registeredEmails(), ['user@example.com']);
      expect(storage.readAll(), completion(isNotEmpty));
    });

    test('rechaza correos normalizados duplicados y contraseñas incorrectas',
        () async {
      await repository.register('A@Example.com', 'a strong password 123');

      await expectLater(
        repository.register(' a@example.com ', 'another strong password'),
        throwsA(isA<AuthFailure>()),
      );
      await expectLater(
        repository.login('a@example.com', 'incorrect password'),
        throwsA(isA<AuthFailure>()),
      );
      await expectLater(
        repository.login('missing@example.com', 'incorrect password'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('cerrar sesión conserva la cuenta y las notas heredadas', () async {
      await storage.write(key: 'note_0', value: 'legacy payload');
      await repository.register('user@example.com', 'a strong password 123');
      await repository.logout();

      expect(await storage.read(key: 'note_0'), 'legacy payload');
      expect(await repository.registeredEmails(), ['user@example.com']);
    });

    test('eliminar la cuenta conserva las notas cifradas heredadas',
        () async {
      final session = await repository.register(
        'user@example.com',
        'a strong password 123',
      );
      await storage.write(
        key: 'secure_vault.notes.v1.${session.user.accountId}.index',
        value: '[]',
      );
      await storage.write(key: 'note_0', value: 'legacy payload');

      await repository.deleteVault('user@example.com');

      expect(await repository.registeredEmails(), isEmpty);
      expect(await storage.read(key: 'note_0'), 'legacy payload');
      expect(
        await storage.read(
          key: 'secure_vault.notes.v1.${session.user.accountId}.index',
        ),
        '[]',
      );
    });
  });
}
