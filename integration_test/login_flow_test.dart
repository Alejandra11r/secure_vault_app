import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault_app/main.dart' as app;

void main() {
  group('Flujo de Login', () {
    testWidgets('Permite iniciar sesión con credenciales válidas',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final loginButton = find.byKey(const Key('login_button'));

      await tester.enterText(emailField, 'alejandra@gmail.com');
      await tester.enterText(passwordField, '123456789');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Mi Caja Fuerte'), findsOneWidget);

      final vaultField = find.byKey(const Key('vault_field'));
      final saveButton = find.byKey(const Key('save_button'));
      await tester.enterText(vaultField, 'Agregando nota 1');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    });
  });
}
