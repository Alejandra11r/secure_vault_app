import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../../../../core/security/encryption_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource, this._encryptionService,
      {Future<void> Function(String accountId)? deleteVaultData,})
      : _deleteVaultData = deleteVaultData;

  final AuthLocalDataSource _localDataSource;
  final EncryptionService _encryptionService;
  final Future<void> Function(String accountId)? _deleteVaultData;

  @override
  Future<List<String>> registeredEmails() async =>
      (await _localDataSource.readAccounts())
          .map((account) => account.metadata.normalizedEmail)
          .toList(growable: false);

  @override
  Future<void> logout() async {
    
  }

  @override
  Future<AuthSession> register(String email, String password) async {
    final normalizedEmail = normalizeEmail(email);
    _validatePassword(password);
    if (await _localDataSource.findByEmail(normalizedEmail) != null) {
      throw const AuthFailure(AuthFailureCode.accountAlreadyExists);
    }

    final accountId = _localDataSource.newAccountId();
    final wrappedKey = await _encryptionService.createWrappedVaultKey(
      accountId: accountId,
      normalizedEmail: normalizedEmail,
      password: password,
    );
    await _localDataSource.createAccount(
      accountId: accountId,
      wrappedKey: wrappedKey,
    );
    final sessionKey = Uint8List.fromList(wrappedKey.vaultKey);
    wrappedKey.vaultKey.fillRange(0, wrappedKey.vaultKey.length, 0);
    return AuthSession(
      user: UserEntity(accountId: accountId, email: normalizedEmail),
      vaultKey: sessionKey,
    );
  }

  @override
  Future<AuthSession> login(String email, String password) async {
    final normalizedEmail = normalizeEmail(email);
    final account = await _localDataSource.findByEmail(normalizedEmail);
    if (account == null) {
      throw const AuthFailure(AuthFailureCode.invalidCredentials);
    }

    try {
      final vaultKey = await _encryptionService.unwrapVaultKey(
        password: password,
        wrapped: account.wrappedKey,
      );
      if (vaultKey.length != EncryptionService.vaultKeyLength) {
        throw const AuthFailure(AuthFailureCode.invalidVault);
      }
      final sessionKey = Uint8List.fromList(vaultKey);
      vaultKey.fillRange(0, vaultKey.length, 0);
      return AuthSession(
        user: UserEntity(
          accountId: account.metadata.accountId,
          email: account.metadata.normalizedEmail,
        ),
        vaultKey: sessionKey,
      );
    } on SecretBoxAuthenticationError {
      throw const AuthFailure(AuthFailureCode.invalidCredentials);
    } on FormatException {
      throw const AuthFailure(AuthFailureCode.invalidVault);
    }
  }

  @override
  Future<void> deleteVault(String email) async {
    final normalizedEmail = normalizeEmail(email);
    final account = await _localDataSource.findByEmail(normalizedEmail);
    if (account == null) return;
    await _deleteVaultData?.call(account.metadata.accountId);
    await _localDataSource.deleteAccount(account.metadata.accountId);
  }

  static String normalizeEmail(String value) {
    final normalized = value.trim().toLowerCase();
    final emailPattern = RegExp(
      r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)+$",
    );
    if (normalized.length > 254 || !emailPattern.hasMatch(normalized)) {
      throw const AuthFailure(AuthFailureCode.invalidEmail);
    }
    return normalized;
  }

  static void _validatePassword(String password) {
    if (password.length < 12 || password.length > 256) {
      throw const AuthFailure(AuthFailureCode.invalidPassword);
    }
  }
}
