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
        child:
            Icon(Icons.shield_outlined, size: size * 0.57, color: Colors.white),
      );
}

class VaultPanel extends StatelessWidget {
  const VaultPanel(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(20),});
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
                offset: Offset(0, 12),),
          ],
        ),
        child: child,
      );
}

class VaultSectionHeading extends StatelessWidget {
  const VaultSectionHeading(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

class VaultQuickAction extends StatelessWidget {
  const VaultQuickAction(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap,
      this.accent = VaultColors.blue,});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) => Material(
        color: VaultColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accent, size: 23),
                const SizedBox(height: 8),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,),
              ],
            ),
          ),
        ),
      );
}
