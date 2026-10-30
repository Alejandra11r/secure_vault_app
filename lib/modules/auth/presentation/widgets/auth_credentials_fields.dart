import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthCredentialsFields extends StatefulWidget {
  const AuthCredentialsFields({
    required this.emailController,
    required this.passwordController,
    required this.registration,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool registration;

  @override
  State<AuthCredentialsFields> createState() => _AuthCredentialsFieldsState();
}

class _AuthCredentialsFieldsState extends State<AuthCredentialsFields> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key('email_field'),
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          autofillHints: const [AutofillHints.username],
          decoration: const InputDecoration(labelText: 'Correo'),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('password_field'),
          controller: widget.passwordController,
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
      ],
    );
  }
}
