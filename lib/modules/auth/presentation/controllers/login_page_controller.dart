import 'package:flutter/material.dart';

import '../../domain/entities/auth_failure.dart';
import '../provider/auth_provider.dart';
import '../widgets/delete_vault_confirmation_dialog.dart';

class LoginPageController {
  Future<void> submit({
    required BuildContext context,
    required AuthProvider auth,
    required bool registration,
    required String email,
    required String password,
    required TextEditingController passwordController,
  }) async {
    try {
      if (registration) {
        await auth.register(email, password);
      } else {
        await auth.login(email, password);
      }
      if (context.mounted) passwordController.clear();
    } on AuthFailure catch (failure) {
      if (!context.mounted) return;
      _showMessage(context, _messageFor(failure));
    } catch (_) {
      if (!context.mounted) return;
      _showMessage(context, 'No se pudo completar la operación.');
    }
  }

  Future<void> confirmDelete({
    required BuildContext context,
    required AuthProvider auth,
    required String rawEmail,
  }) async {
    final email = rawEmail.trim().toLowerCase();
    if (email.isEmpty || !auth.registeredEmails.contains(email)) {
      _showMessage(context, 'Ingresa el correo de la caja fuerte.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteVaultConfirmationDialog(email: email),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await auth.deleteVault(email);
    } catch (_) {
      if (!context.mounted) return;
      _showMessage(context, 'No se pudo eliminar la caja fuerte.');
    }
  }

  String _messageFor(AuthFailure failure) => switch (failure.code) {
        AuthFailureCode.accountAlreadyExists => 'La cuenta ya existe.',
        AuthFailureCode.invalidEmail => 'Ingresa un correo válido.',
        AuthFailureCode.invalidPassword =>
          'La contraseña debe tener entre 12 y 256 caracteres.',
        AuthFailureCode.invalidVault =>
          'No se pudo abrir la caja fuerte. Revisa sus datos.',
        AuthFailureCode.invalidCredentials =>
          'Correo o contraseña incorrectos.',
      };

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
