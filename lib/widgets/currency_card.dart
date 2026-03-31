import 'package:flutter/material.dart';
import '../models/currency.dart';

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
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: Colors.red[600]),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: currency.isCrypto
                      ? [const Color(0xFFF5F3FF), const Color(0xFFE0E7FF)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFECFEFF)],
                ),
              ),
              child: Center(
                child: Text(
                  avatarLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: currency.isCrypto
                        ? const Color(0xFF4338CA)
                        : const Color(0xFF1D4ED8),
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
                    currency.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '1 $baseCurrency = ${formatNumber(currency.rate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatNumber(currency.converted),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
