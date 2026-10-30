import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<List<String>> registeredEmails();
  Future<AuthSession> register(String email, String password);
  Future<AuthSession> login(String email, String password);
  Future<void> logout();
  Future<void> deleteVault(String email);
}
