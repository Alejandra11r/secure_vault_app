import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'package:secure_vault_app/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/delete_vault_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/login_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/logout_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/register_use_case.dart';
import 'package:secure_vault_app/modules/auth/presentation/provider/auth_provider.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('AuthProvider', () {
    late AuthProvider provider;

    setUp(() async {
      final storage = FakeSecureStorage();
      final repository = AuthRepositoryImpl(
        AuthLocalDataSource(storage),
        EncryptionService(argonMemoryKiB: 19 * 1024),
      );
      provider = AuthProvider(
        loginUseCase: LoginUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        deleteVaultUseCase: DeleteVaultUseCase(repository),
      );
      await provider.initialize();
    });

    test('registration unlocks, lock clears key, and login restores access',
        () async {
      await provider.register('user@example.com', 'a strong password 123');
      final originalKey = provider.vaultKey!;
      expect(provider.isUnlocked, isTrue);
      expect(provider.user?.email, 'user@example.com');

      provider.lock();
      expect(provider.status, AuthStatus.locked);
      expect(provider.vaultKey, isNull);
      expect(originalKey.every((byte) => byte == 0), isTrue);

      await provider.login('user@example.com', 'a strong password 123');
      expect(provider.isUnlocked, isTrue);
      expect(provider.vaultKey, isNotNull);
    });

    test('logout locks but preserves registered account', () async {
      await provider.register('user@example.com', 'a strong password 123');
      await provider.logout();

      expect(provider.status, AuthStatus.locked);
      expect(provider.user, isNull);
      expect(provider.vaultKey, isNull);
      expect(provider.registeredEmails, ['user@example.com']);
    });
  });
}
