import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cfColors = theme.extension<CoinFluxColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 64,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Your list is empty.\nTap "Add Asset" above to select which rates you want to see.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: cfColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
