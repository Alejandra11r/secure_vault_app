import 'package:flutter/material.dart';

import '../theme/vault_theme.dart';

class VaultPanel extends StatelessWidget {
  const VaultPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: VaultColors.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: VaultColors.border.withValues(alpha: 0.8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 26,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: child,
      );
}
