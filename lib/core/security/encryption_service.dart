import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class EncryptionService {
  final _uuid = const Uuid();

  String generateKey() {
    final key = List.generate(32, (_) => _uuid.v4().codeUnitAt(0) % 256);
    return base64Url.encode(key);
  }

  Map<String, String> encryptText(String plain, String base64Key) {
    final key = Key.fromBase64(base64Key);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plain, iv: iv);

    return {
      'cipher': encrypted.base64,
      'iv': iv.base64,
    };
  }

  String decryptText(String base64Cipher, String base64Key, String base64Iv) {
    final key = Key.fromBase64(base64Key);
    final iv = IV.fromBase64(base64Iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = Encrypted.fromBase64(base64Cipher);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
