import '../datasources/auth_local_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final token = await localDataSource.generateToken();
    await localDataSource.saveToken(token);
    return UserEntity(email: email, token: token);
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAll();
  }
}
