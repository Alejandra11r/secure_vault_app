import 'package:flutter/foundation.dart';
import 'package:secure_vault_app/modules/auth/domain/entities/user_entity.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/login_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/logout_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  UserEntity? _user;

  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  UserEntity? get user => _user;

  Future<bool> login(String email, String password) async {
    _user = await loginUseCase(email, password);
    notifyListeners();
    return _user != null;
  }

  Future<void> logout() async {
    await logoutUseCase();
    _user = null;
    notifyListeners();
  }
}
