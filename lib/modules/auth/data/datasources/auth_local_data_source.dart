import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  AuthLocalDataSource(this.secureStorage);

  Future<String> generateToken() async {
    return const Uuid().v4();
  }

  Future<void> saveToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<void> clearAll() async {
    await secureStorage.deleteAll();
  }
}
