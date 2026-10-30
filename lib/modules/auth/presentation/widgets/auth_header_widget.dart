import 'package:flutter/material.dart';

import '../../../../app/theme/vault_theme.dart';
import '../../../../app/widgets/vault_brand_mark.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({required this.registration, super.key});

  final bool registration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: VaultBrandMark(size: 72)),
        const SizedBox(height: 18),
        Text(
          registration ? 'Crear caja fuerte' : 'Desbloquear caja fuerte',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          registration
              ? 'Crea tu espacio privado en este dispositivo.'
              : 'Tus notas y archivos, protegidos en tu dispositivo.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: VaultColors.muted),
        ),
      ],
    );
  }
}
