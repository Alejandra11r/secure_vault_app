import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_vault_app/main.dart' as app;
import 'package:uuid/uuid.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo de inicio de sesión', () {
    testWidgets('Registra una cuenta local y guarda una nota cifrada',
        (tester) async {
      await app.main();
      await tester.pumpAndSettle();

      final createAccount = find.text('Crear una cuenta local');
      if (createAccount.evaluate().isNotEmpty) {
        await tester.tap(createAccount);
        await tester.pumpAndSettle();
      }

      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final loginButton = find.byKey(const Key('login_button'));

      await tester.enterText(
        emailField,
        'test-${const Uuid().v4()}@example.com',
      );
      await tester.enterText(passwordField, 'a strong password 123');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Mi Caja Fuerte'), findsOneWidget);

      final vaultField = find.byKey(const Key('vault_field'));
      final saveButton = find.byKey(const Key('save_button'));
      const noteContent = 'Nota creada en la prueba de integración';
      await tester.enterText(vaultField, noteContent);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      final notesTab = find.bySemanticsIdentifier('vault_notes_tab');
      expect(notesTab, findsOneWidget);
      await tester.tap(notesTab);
      await tester.pumpAndSettle();
      expect(find.text(noteContent), findsOneWidget);
    });
  });
}
