import 'package:flutter/material.dart';

import '../theme/vault_theme.dart';

class VaultBackdrop extends StatelessWidget {
  const VaultBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF101D34),
              VaultColors.background,
              Color(0xFF090F1B),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -140,
              right: -90,
              child: _Glow(color: VaultColors.blue.withValues(alpha: 0.12)),
            ),
            Positioned(
              bottom: -180,
              left: -100,
              child: _Glow(color: VaultColors.violet.withValues(alpha: 0.1)),
            ),
            child,
          ],
        ),
      );
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 110, spreadRadius: 35),
            ],
          ),
        ),
      );
}
