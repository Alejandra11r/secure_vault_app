import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';

class VaultLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final EncryptionService encryptionService;

  VaultLocalDataSource(this.secureStorage)
      : encryptionService = EncryptionService();

  Future<void> saveNote(String id, String plainText) async {
    final key = encryptionService.generateKey();
    final encrypted = encryptionService.encryptText(plainText, key);

    final payload = json.encode({
      'key': key,
      'iv': encrypted['iv'], 
      'cipher': encrypted['cipher'],
    });

    await secureStorage.write(key: 'note_$id', value: payload);
  }

  Future<List<Map<String, String>>> getNotes() async {
    final all = <Map<String, String>>[];

    for (int i = 0; i < 20; i++) {
      final k = 'note_$i';
      final v = await secureStorage.read(key: k);
      if (v != null) {
        try {
          final obj = json.decode(v);
          all.add({
            'id': '$i',
            'key': obj['key'],
            'iv': obj['iv'],
            'cipher': obj['cipher']
          });
        } catch (_) {}
      }
    }
    return all;
  }

  Future<void> deleteNote(String id) async {
    await secureStorage.delete(key: 'note_$id');
  }
}
