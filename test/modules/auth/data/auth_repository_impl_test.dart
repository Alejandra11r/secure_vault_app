import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'package:secure_vault_app/modules/auth/data/repositories/auth_repository_impl.dart';

import '../../../mocks/fake_secure_storage.dart';

void main() {
  group('AuthRepositoryImpl', () {
    test('login generates a token and stores it', () async {
      final storage = FakeSecureStorage();
      final local = AuthLocalDataSource(storage);
      final repo = AuthRepositoryImpl(local);

      final user = await repo.login('a@b.com', 'pwd');
      expect(user.email, 'a@b.com');
      expect(user.token, isNotEmpty);

      final stored = await storage.read(key: 'auth_token');
      expect(stored, isNotNull);
    });

    test('logout clears storage', () async {
      final storage = FakeSecureStorage();
      final local = AuthLocalDataSource(storage);
      final repo = AuthRepositoryImpl(local);

      await repo.login('a@b.com', 'pwd');
      await repo.logout();
      final stored = await storage.read(key: 'auth_token');
      expect(stored, isNull);
    });
  });
}
