import 'package:flutter/material.dart';

import 'login_button_widget.dart';

class AuthActionsWidget extends StatelessWidget {
  const AuthActionsWidget({
    required this.registration,
    required this.isBusy,
    required this.hasRegisteredAccounts,
    required this.onSubmit,
    required this.onGoToLogin,
    required this.onGoToRegistration,
    required this.onDeleteVault,
    super.key,
  });

  final bool registration;
  final bool isBusy;
  final bool hasRegisteredAccounts;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;
  final VoidCallback onGoToRegistration;
  final VoidCallback onDeleteVault;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        if (isBusy)
          const Center(child: CircularProgressIndicator())
        else
          LoginButtonWidget(
            label: registration ? 'Crear cuenta' : 'Ingresar',
            onPressed: onSubmit,
          ),
        if (registration) ...[
          if (hasRegisteredAccounts)
            TextButton(
              onPressed: onGoToLogin,
              child: const Text('Ya tengo una cuenta'),
            ),
        ] else ...[
          TextButton(
            onPressed: onGoToRegistration,
            child: const Text('Crear una cuenta local'),
          ),
          TextButton(
            onPressed: onDeleteVault,
            child: const Text('Eliminar caja fuerte y comenzar de nuevo'),
          ),
        ],
      ],
    );
  }
}
