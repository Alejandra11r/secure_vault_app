import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/login_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/logout_use_case.dart';
import 'package:secure_vault_app/modules/auth/presentation/provider/auth_provider.dart';
import 'package:secure_vault_app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'package:secure_vault_app/modules/auth/data/repositories/auth_repository_impl.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('AuthProvider', () {
    test('login sets user and token', () async {
      final storage = FakeSecureStorage();
      final local = AuthLocalDataSource(storage);
      final repo = AuthRepositoryImpl(local);

      
      final provider = AuthProvider(
          loginUseCase: LoginUseCase(repo), logoutUseCase: LogoutUseCase(repo));

      final ok = await provider.login('a@b.com', 'pwd');
      expect(ok, true);
      expect(provider.user, isNotNull);
      expect(provider.user!.token, isNotEmpty);
    });

    test('logout clears user', () async {
      final storage = FakeSecureStorage();
      final local = AuthLocalDataSource(storage);
      final repo = AuthRepositoryImpl(local);
      final provider = AuthProvider(
          loginUseCase: LoginUseCase(repo), logoutUseCase: LogoutUseCase(repo));

      await provider.login('a@b.com', 'pwd');
      await provider.logout();
      expect(provider.user, isNull);
    });
  });
}
