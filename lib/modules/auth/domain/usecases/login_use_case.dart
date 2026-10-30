import '../../domain/repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<List<String>> registeredEmails() => repository.registeredEmails();

  Future<AuthSession> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
