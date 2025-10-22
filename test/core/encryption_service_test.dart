import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    testWidgets('encrypts and decrypts a string correctly', (tester) async {
      final service = EncryptionService();
      final key = service.generateKey();
      final plain = 'texto secreto';

      final enc = service.encryptText(plain, key);
      expect(enc.containsKey('cipher'), true);
      expect(enc.containsKey('iv'), true);

      final decrypted = service.decryptText(enc['cipher']!, key, enc['iv']!);
      expect(decrypted, plain);
    });
  });
}
