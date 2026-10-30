import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/security/encryption_service.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._secureStorage);

  static const _indexKey = 'secure_vault.auth.account_ids.v1';
  static const _accountPrefix = 'secure_vault.auth.account.v1.';

  final FlutterSecureStorage _secureStorage;

  Future<List<String>> accountIds() async {
    final value = await _secureStorage.read(key: _indexKey);
    if (value == null) return const [];
    final decoded = jsonDecode(value);
    if (decoded is! List<dynamic> || decoded.any((id) => id is! String)) {
      throw const FormatException('Invalid local account index.');
    }
    return decoded.cast<String>();
  }

  Future<List<AccountRecord>> readAccounts() async {
    final ids = await accountIds();
    final records = <AccountRecord>[];
    for (final id in ids) {
      final value = await _secureStorage.read(key: '$_accountPrefix$id');
      if (value == null) continue;
      records.add(
        AccountRecord.fromJson(
          jsonDecode(value) as Map<String, dynamic>,
        ),
      );
    }
    return records;
  }

  Future<AccountRecord?> findByEmail(String normalizedEmail) async {
    for (final record in await readAccounts()) {
      if (record.metadata.normalizedEmail == normalizedEmail) return record;
    }
    return null;
  }

  Future<void> createAccount({
    required String accountId,
    required WrappedVaultKey wrappedKey,
  }) async {
    final ids = await accountIds();
    if (ids.contains(accountId)) {
      throw StateError('Account identifier already exists.');
    }

    final record = AccountRecord(wrappedKey: wrappedKey);
    await _secureStorage.write(
      key: '$_accountPrefix$accountId',
      value: jsonEncode(record.toJson()),
    );
    try {
      await _secureStorage.write(
        key: _indexKey,
        value: jsonEncode([...ids, accountId]),
      );
    } catch (_) {
      await _secureStorage.delete(key: '$_accountPrefix$accountId');
      rethrow;
    }
  }

  Future<void> deleteAccount(String accountId) async {
    final ids = await accountIds();
    if (!ids.contains(accountId)) return;
    await _secureStorage.write(
      key: _indexKey,
      value: jsonEncode(ids.where((id) => id != accountId).toList()),
    );
    await _secureStorage.delete(key: '$_accountPrefix$accountId');
  }

  String newAccountId() => const Uuid().v4();
}

class AccountRecord {
  const AccountRecord({required this.wrappedKey});

  final WrappedVaultKey wrappedKey;
  VaultKeyMetadata get metadata => wrappedKey.metadata;

  Map<String, Object> toJson() => wrappedKey.toJson();

  factory AccountRecord.fromJson(Map<String, dynamic> json) =>
      AccountRecord(wrappedKey: WrappedVaultKey.fromJson(json));
}
