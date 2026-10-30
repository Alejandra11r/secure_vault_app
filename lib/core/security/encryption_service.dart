import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class EncryptionService {
  static const int formatVersion = 1;
  static const int saltLength = 16;
  static const int vaultKeyLength = 32;
  static const int nonceLength = 12;

  
  static const int memoryKiB = 32 * 1024;
  static const int iterations = 2;
  static const int parallelism = 1;
  static const int hashLength = 32;

  final Argon2id _argon2id;
  final Hkdf _hkdf;
  final AesGcm _aesGcm;
  final List<int> Function(int length) _randomBytes;
  final int _memoryKiB;
  final int _iterations;
  final int _parallelism;

  EncryptionService({
    Argon2id? argon2id,
    Hkdf? hkdf,
    AesGcm? aesGcm,
    List<int> Function(int length)? randomBytes,
    int argonMemoryKiB = memoryKiB,
    int argonIterations = iterations,
    int argonParallelism = parallelism,
  })  : _argon2id = argon2id ??
            Argon2id(
              memory: argonMemoryKiB,
              iterations: argonIterations,
              parallelism: argonParallelism,
              hashLength: hashLength,
            ),
        _hkdf = hkdf ?? Hkdf(hmac: Hmac.sha256(), outputLength: vaultKeyLength),
        _aesGcm = aesGcm ?? AesGcm.with256bits(),
        _randomBytes = randomBytes ?? _secureRandomBytes,
        _memoryKiB = argonMemoryKiB,
        _iterations = argonIterations,
        _parallelism = argonParallelism;

  static List<int> _secureRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  Future<WrappedVaultKey> createWrappedVaultKey({
    required String accountId,
    required String normalizedEmail,
    required String password,
  }) async {
    final salt = _randomBytes(saltLength);
    final vaultKey = _randomBytes(vaultKeyLength);
    final metadata = VaultKeyMetadata(
      accountId: accountId,
      normalizedEmail: normalizedEmail,
      salt: base64UrlEncode(salt),
      memoryKiB: _memoryKiB,
      iterations: _iterations,
      parallelism: _parallelism,
      hashLength: hashLength,
    );
    final wrappingKey = await _deriveWrappingKey(password, metadata);
    final nonce = _randomBytes(nonceLength);
    final box = await _aesGcm.encrypt(
      vaultKey,
      secretKey: SecretKey(wrappingKey),
      nonce: nonce,
      aad: metadata.toAad(),
    );
    return WrappedVaultKey(
      metadata: metadata,
      nonce: box.nonce,
      cipherText: box.cipherText,
      mac: box.mac.bytes,
      vaultKey: vaultKey,
    );
  }

  Future<List<int>> unwrapVaultKey({
    required String password,
    required WrappedVaultKey wrapped,
  }) async {
    wrapped.metadata.validate();
    if (wrapped.nonce.length != nonceLength ||
        wrapped.mac.length != 16 ||
        wrapped.cipherText.length != vaultKeyLength) {
      throw const FormatException('Invalid vault key envelope.');
    }
    final wrappingKey = await _deriveWrappingKey(password, wrapped.metadata);
    return _aesGcm.decrypt(
      SecretBox(
        wrapped.cipherText,
        nonce: wrapped.nonce,
        mac: Mac(wrapped.mac),
      ),
      secretKey: SecretKey(wrappingKey),
      aad: wrapped.metadata.toAad(),
    );
  }

  Future<EncryptedContent> encryptContent({
    required String plainText,
    required List<int> vaultKey,
    required List<int> associatedData,
  }) async {
    return encryptBytes(
      plainBytes: utf8.encode(plainText),
      vaultKey: vaultKey,
      associatedData: associatedData,
    );
  }

  Future<EncryptedContent> encryptBytes({
    required List<int> plainBytes,
    required List<int> vaultKey,
    required List<int> associatedData,
  }) async {
    final box = await _aesGcm.encrypt(
      plainBytes,
      secretKey: SecretKey(vaultKey),
      nonce: _randomBytes(nonceLength),
      aad: associatedData,
    );
    return EncryptedContent(
      nonce: box.nonce,
      cipherText: box.cipherText,
      mac: box.mac.bytes,
    );
  }

  Future<String> decryptContent({
    required EncryptedContent content,
    required List<int> vaultKey,
    required List<int> associatedData,
  }) async {
    return utf8.decode(await decryptBytes(
      content: content,
      vaultKey: vaultKey,
      associatedData: associatedData,
    ),);
  }

  Future<List<int>> decryptBytes({
    required EncryptedContent content,
    required List<int> vaultKey,
    required List<int> associatedData,
  }) async {
    final plainBytes = await _aesGcm.decrypt(
      SecretBox(
        content.cipherText,
        nonce: content.nonce,
        mac: Mac(content.mac),
      ),
      secretKey: SecretKey(vaultKey),
      aad: associatedData,
    );
    return plainBytes;
  }

  Future<List<int>> _deriveWrappingKey(
    String password,
    VaultKeyMetadata metadata,
  ) async {
    metadata.validate();
    final passwordRoot = await _argon2id.deriveKeyFromPassword(
      password: password,
      nonce: base64Url.decode(metadata.salt),
    );
    return (await _hkdf.deriveKey(
      secretKey: passwordRoot,
      nonce: utf8.encode('secure-vault/hkdf-salt/v1'),
      info: utf8.encode('secure-vault/v1/wrap-key/${metadata.accountId}'),
    ))
        .extractBytes();
  }
}

class EncryptedContent {
  const EncryptedContent({
    required this.nonce,
    required this.cipherText,
    required this.mac,
  });

  final List<int> nonce;
  final List<int> cipherText;
  final List<int> mac;
}

class VaultKeyMetadata {
  const VaultKeyMetadata({
    required this.accountId,
    required this.normalizedEmail,
    required this.salt,
    required this.memoryKiB,
    required this.iterations,
    required this.parallelism,
    required this.hashLength,
    this.version = EncryptionService.formatVersion,
  });

  final String accountId;
  final String normalizedEmail;
  final String salt;
  final int memoryKiB;
  final int iterations;
  final int parallelism;
  final int hashLength;
  final int version;

  void validate() {
    final decodedSalt = base64Url.decode(salt);
    if (version != EncryptionService.formatVersion ||
        accountId.isEmpty ||
        normalizedEmail.isEmpty ||
        decodedSalt.length != EncryptionService.saltLength ||
        memoryKiB < 19 * 1024 ||
        memoryKiB > 64 * 1024 ||
        iterations < 1 ||
        iterations > 4 ||
        parallelism != 1 ||
        hashLength != EncryptionService.hashLength) {
      throw const FormatException('Unsupported vault key metadata.');
    }
  }

  List<int> toAad() => utf8.encode(
        jsonEncode([
          'secure-vault-key-envelope',
          version,
          accountId,
          normalizedEmail,
          'argon2id',
          memoryKiB,
          iterations,
          parallelism,
          hashLength,
          salt,
          'hkdf-sha256:wrap-key:v1',
          'aes-256-gcm',
        ]),
      );

  Map<String, Object> toJson() => {
        'version': version,
        'accountId': accountId,
        'normalizedEmail': normalizedEmail,
        'salt': salt,
        'memoryKiB': memoryKiB,
        'iterations': iterations,
        'parallelism': parallelism,
        'hashLength': hashLength,
      };

  factory VaultKeyMetadata.fromJson(Map<String, dynamic> json) =>
      VaultKeyMetadata(
        version: json['version'] as int,
        accountId: json['accountId'] as String,
        normalizedEmail: json['normalizedEmail'] as String,
        salt: json['salt'] as String,
        memoryKiB: json['memoryKiB'] as int,
        iterations: json['iterations'] as int,
        parallelism: json['parallelism'] as int,
        hashLength: json['hashLength'] as int,
      );
}

class WrappedVaultKey {
  const WrappedVaultKey({
    required this.metadata,
    required this.nonce,
    required this.cipherText,
    required this.mac,
    required this.vaultKey,
  });

  final VaultKeyMetadata metadata;
  final List<int> nonce;
  final List<int> cipherText;
  final List<int> mac;

  /// Se entrega al registrar y se conserva solo durante la sesión.
  final List<int> vaultKey;

  Map<String, Object> toJson() => {
        'metadata': metadata.toJson(),
        'nonce': base64UrlEncode(nonce),
        'cipherText': base64UrlEncode(cipherText),
        'mac': base64UrlEncode(mac),
      };

  factory WrappedVaultKey.fromJson(Map<String, dynamic> json) =>
      WrappedVaultKey(
        metadata: VaultKeyMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>,
        ),
        nonce: base64Url.decode(json['nonce'] as String),
        cipherText: base64Url.decode(json['cipherText'] as String),
        mac: base64Url.decode(json['mac'] as String),
        vaultKey: const [],
      );
}
