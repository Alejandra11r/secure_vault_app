import 'package:flutter/material.dart';

import '../../../../app/theme/vault_theme.dart';

class AuthSecurityNoteWidget extends StatelessWidget {
  const AuthSecurityNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline,
          size: 15,
          color: VaultColors.muted,
        ),
        const SizedBox(width: 7),
        Text(
          'Las claves permanecen en este dispositivo',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: VaultColors.muted),
        ),
      ],
    );
  }
}
