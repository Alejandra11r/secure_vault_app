import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/auth_failure.dart';
import '../../../../app/theme/vault_theme.dart';
import '../../../../app/widgets/vault_ui.dart';
import '../provider/auth_provider.dart';
import '../widgets/login_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.registration = false});

  final bool registration;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _accountPrefilled = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_accountPrefilled && !widget.registration) {
      _emailCtrl.text = context.read<AuthProvider>().user?.email ?? '';
      _accountPrefilled = true;
    }
  }

  Future<void> _submit(AuthProvider auth) async {
    final password = _passCtrl.text;
    try {
      if (widget.registration) {
        await auth.register(_emailCtrl.text, password);
      } else {
        await auth.login(_emailCtrl.text, password);
      }
      // Successful auth redirects away from this page and disposes its fields.
      if (mounted) _passCtrl.clear();
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      final message = switch (failure.code) {
        AuthFailureCode.accountAlreadyExists => 'La cuenta ya existe.',
        AuthFailureCode.invalidEmail => 'Ingresa un correo válido.',
        AuthFailureCode.invalidPassword =>
          'La contraseña debe tener entre 12 y 256 caracteres.',
        AuthFailureCode.invalidVault =>
          'No se pudo abrir la caja fuerte. Revisa sus datos.',
        AuthFailureCode.invalidCredentials =>
          'Correo o contraseña incorrectos.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar la operación.')),
      );
    }
  }

  Future<void> _confirmDelete(AuthProvider auth) async {
    final email = _emailCtrl.text.trim().toLowerCase();
    if (email.isEmpty || !auth.registeredEmails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el correo de la caja fuerte.')),
      );
      return;
    }

    final confirmationCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar caja fuerte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Se eliminará la cuenta local $email. Esta acción no se puede deshacer.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Las notas antiguas AES-CBC se conservarán sin migrarse y no aparecerán en la nueva caja fuerte.',
            ),
            const SizedBox(height: 12),
            const Text('Escribe ELIMINAR para confirmar.'),
            TextField(
              controller: confirmationCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              confirmationCtrl.text == 'ELIMINAR',
            ),
            child: const Text('Eliminar caja fuerte'),
          ),
        ],
      ),
    );
    confirmationCtrl.dispose();
    if (confirmed != true || !mounted) return;

    try {
      await auth.deleteVault(email);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar la caja fuerte.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final title =
        widget.registration ? 'Crear caja fuerte' : 'Desbloquear caja fuerte';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: Text(
              widget.registration ? 'Nueva caja fuerte' : 'Acceso privado',),),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  const Center(child: VaultBrandMark(size: 72)),
                  const SizedBox(height: 18),
                  Text(title,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),),
                  const SizedBox(height: 8),
                  Text(
                    widget.registration
                        ? 'Crea tu espacio privado en este dispositivo.'
                        : 'Tus notas y archivos, protegidos en tu dispositivo.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: VaultColors.muted),
                  ),
                  const SizedBox(height: 20),
                  VaultPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          key: const Key('email_field'),
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username],
                          decoration:
                              const InputDecoration(labelText: 'Correo'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          key: const Key('password_field'),
                          controller: _passCtrl,
                          obscureText: _obscurePassword,
                          autocorrect: false,
                          enableSuggestions: false,
                          autofillHints: widget.registration
                              ? const [AutofillHints.newPassword]
                              : const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: widget.registration
                                ? 'Contraseña (mínimo 12 caracteres)'
                                : 'Contraseña',
                            suffixIcon: IconButton(
                              key: const Key('toggle_password_visibility'),
                              tooltip: _obscurePassword
                                  ? 'Mostrar contraseña'
                                  : 'Ocultar contraseña',
                              onPressed: _togglePasswordVisibility,
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (auth.isBusy)
                          const Center(child: CircularProgressIndicator())
                        else
                          LoginButtonWidget(
                            label: widget.registration
                                ? 'Crear cuenta'
                                : 'Ingresar',
                            onPressed: () => _submit(auth),
                          ),
                        if (widget.registration) ...[
                          if (auth.registeredEmails.isNotEmpty)
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Ya tengo una cuenta'),
                            ),
                        ] else ...[
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text('Crear una cuenta local'),
                          ),
                          TextButton(
                            onPressed: () => _confirmDelete(auth),
                            child: const Text(
                                'Eliminar caja fuerte y comenzar de nuevo',),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 15, color: VaultColors.muted,),
                      const SizedBox(width: 7),
                      Text(
                        'Las claves permanecen en este dispositivo',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: VaultColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
