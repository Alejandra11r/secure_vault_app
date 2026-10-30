import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';

void main() {
  group('Servicio de cifrado', () {
    late EncryptionService service;

    setUp(() {
      service = EncryptionService(argonMemoryKiB: 19 * 1024);
    });

    test('envuelve y recupera una clave aleatoria de bóveda', () async {
      final wrapped = await service.createWrappedVaultKey(
        accountId: 'account-1',
        normalizedEmail: 'a@example.com',
        password: 'correct horse battery staple',
      );

      final unwrapped = await service.unwrapVaultKey(
        password: 'correct horse battery staple',
        wrapped: WrappedVaultKey.fromJson(wrapped.toJson()),
      );

      expect(unwrapped, wrapped.vaultKey);
      expect(wrapped.nonce, hasLength(12));
      expect(wrapped.mac, hasLength(16));
      expect(wrapped.toJson().containsKey('vaultKey'), isFalse);
    });

    test('rechaza una contraseña incorrecta y parámetros KDF alterados', () async {
      final wrapped = await service.createWrappedVaultKey(
        accountId: 'account-1',
        normalizedEmail: 'a@example.com',
        password: 'correct horse battery staple',
      );

      await expectLater(
        service.unwrapVaultKey(
          password: 'incorrect password',
          wrapped: wrapped,
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );

      final changedMetadata = VaultKeyMetadata(
        accountId: wrapped.metadata.accountId,
        normalizedEmail: wrapped.metadata.normalizedEmail,
        salt: wrapped.metadata.salt,
        memoryKiB: wrapped.metadata.memoryKiB,
        iterations: wrapped.metadata.iterations + 1,
        parallelism: wrapped.metadata.parallelism,
        hashLength: wrapped.metadata.hashLength,
      );
      final tampered = WrappedVaultKey(
        metadata: changedMetadata,
        nonce: wrapped.nonce,
        cipherText: wrapped.cipherText,
        mac: wrapped.mac,
        vaultKey: const [],
      );
      await expectLater(
        service.unwrapVaultKey(
          password: 'correct horse battery staple',
          wrapped: tampered,
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });

    test('detecta contenido y datos asociados alterados', () async {
      final key = List<int>.generate(32, (index) => index);
      final encrypted = await service.encryptContent(
        plainText: 'nota privada',
        vaultKey: key,
        associatedData: utf8.encode('account-1:note-1'),
      );
      expect(
        await service.decryptContent(
          content: encrypted,
          vaultKey: key,
          associatedData: utf8.encode('account-1:note-1'),
        ),
        'nota privada',
      );
      await expectLater(
        service.decryptContent(
          content: encrypted,
          vaultKey: key,
          associatedData: utf8.encode('account-2:note-1'),
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
      final changedCipher = EncryptedContent(
        nonce: encrypted.nonce,
        cipherText: [
          encrypted.cipherText.first ^ 1,
          ...encrypted.cipherText.skip(1),
        ],
        mac: encrypted.mac,
      );
      await expectLater(
        service.decryptContent(
          content: changedCipher,
          vaultKey: key,
          associatedData: utf8.encode('account-1:note-1'),
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });

    test('rechaza perfiles KDF no admitidos antes de derivar', () async {
      final metadata = VaultKeyMetadata(
        accountId: 'account-1',
        normalizedEmail: 'a@example.com',
        salt: base64UrlEncode(List<int>.filled(16, 1)),
        memoryKiB: 1024 * 1024,
        iterations: 2,
        parallelism: 1,
        hashLength: 32,
      );
      final wrapped = WrappedVaultKey(
        metadata: metadata,
        nonce: List<int>.filled(12, 0),
        cipherText: List<int>.filled(32, 0),
        mac: List<int>.filled(16, 0),
        vaultKey: const [],
      );
      await expectLater(
        service.unwrapVaultKey(password: 'ignored', wrapped: wrapped),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
