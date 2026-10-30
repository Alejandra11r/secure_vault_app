import 'package:flutter/foundation.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/delete_vault_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/register_use_case.dart';

enum AuthStatus { initializing, setupRequired, locked, unlocked }

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required DeleteVaultUseCase deleteVaultUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerUseCase = registerUseCase,
        _deleteVaultUseCase = deleteVaultUseCase;

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final DeleteVaultUseCase _deleteVaultUseCase;

  AuthStatus _status = AuthStatus.initializing;
  UserEntity? _user;
  Uint8List? _vaultKey;
  List<String> _registeredEmails = const [];
  bool _busy = false;

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  Uint8List? get vaultKey => _vaultKey;
  List<String> get registeredEmails => List.unmodifiable(_registeredEmails);
  bool get isBusy => _busy;
  bool get isUnlocked => _status == AuthStatus.unlocked;

  Future<void> initialize() async {
    _registeredEmails = await _loginUseCase.registeredEmails();
    _status = _registeredEmails.isEmpty
        ? AuthStatus.setupRequired
        : AuthStatus.locked;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    if (_busy) return;
    _busy = true;
    notifyListeners();
    try {
      final session = await _registerUseCase(email, password);
      _clearKey();
      _user = session.user;
      _vaultKey = session.vaultKey;
      _registeredEmails = [..._registeredEmails, session.user.email];
      _status = AuthStatus.unlocked;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    await _runAuthOperation(() => _loginUseCase(email, password));
  }

  Future<void> _runAuthOperation(
    Future<AuthSession> Function() operation,
  ) async {
    if (_busy) return;
    _busy = true;
    notifyListeners();
    try {
      final session = await operation();
      _clearKey();
      _user = session.user;
      _vaultKey = session.vaultKey;
      _status = AuthStatus.unlocked;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  
  void lock() {
    _clearKey();
    _status = _registeredEmails.isEmpty
        ? AuthStatus.setupRequired
        : AuthStatus.locked;
    notifyListeners();
  }

  
  Future<void> logout() async {
    await _logoutUseCase();
    _clearKey();
    _user = null;
    _status = _registeredEmails.isEmpty
        ? AuthStatus.setupRequired
        : AuthStatus.locked;
    notifyListeners();
  }

  Future<void> deleteVault(String email) async {
    await _deleteVaultUseCase(email);
    await logout();
    _registeredEmails = await _loginUseCase.registeredEmails();
    _status = _registeredEmails.isEmpty
        ? AuthStatus.setupRequired
        : AuthStatus.locked;
    notifyListeners();
  }

  void _clearKey() {
    final key = _vaultKey;
    if (key != null) key.fillRange(0, key.length, 0);
    _vaultKey = null;
  }
}
