import 'package:flutter/material.dart';

import '../theme/vault_theme.dart';

class VaultQuickAction extends StatelessWidget {
  const VaultQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.accent = VaultColors.blue,
  });

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
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      );
}
