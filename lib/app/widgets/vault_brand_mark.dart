import 'package:flutter/material.dart';

import '../theme/vault_theme.dart';

class VaultBrandMark extends StatelessWidget {
  const VaultBrandMark({super.key, this.size = 68});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [VaultColors.blue, VaultColors.violet],
          ),
          boxShadow: [
            BoxShadow(
              color: VaultColors.blue.withValues(alpha: 0.27),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.shield_outlined,
          size: size * 0.57,
          color: Colors.white,
        ),
      );
}
