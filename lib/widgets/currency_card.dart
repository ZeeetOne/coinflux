import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../theme/app_theme.dart';

class CurrencyCard extends StatelessWidget {
  final ConvertedCurrency currency;
  final String baseCurrency;
  final VoidCallback onRemove;

  const CurrencyCard({
    super.key,
    required this.currency,
    required this.baseCurrency,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cfColors = theme.extension<CoinFluxColors>()!;
    final avatarLabel = currency.code.length > 4
        ? '${currency.code.substring(0, 3)}..'
        : currency.code;

    return Dismissible(
      key: Key(currency.code),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: cfColors.deleteBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: cfColors.deleteForeground),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cfColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: currency.isCrypto
                    ? cfColors.avatarCryptoGradient
                    : cfColors.avatarFiatGradient,
              ),
              child: Center(
                child: Text(
                  avatarLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: currency.isCrypto
                        ? cfColors.avatarCryptoForeground
                        : cfColors.avatarFiatForeground,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyLabel(currency.code, currency.name),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '1 $baseCurrency = ${formatNumber(currency.rate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: cfColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatNumber(currency.converted),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
