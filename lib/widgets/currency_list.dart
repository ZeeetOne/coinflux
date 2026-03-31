import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../providers/preferences_provider.dart';
import '../providers/rates_provider.dart';
import 'currency_card.dart';
import 'empty_state.dart';

class CurrencyList extends ConsumerWidget {
  const CurrencyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider).asData?.value;
    final ratesAsync = ref.watch(ratesProvider);

    if (prefs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ratesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) {
        FlutterNativeSplash.remove();
        return Center(
          child: Text(
            'Failed to load rates.\nPull down to retry.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        );
      },
      data: (ratesState) {
        FlutterNativeSplash.remove();
        final displayList = prefs.watchlist
            .where(
              (c) =>
                  c != prefs.baseCurrency && ratesState.rates.containsKey(c),
            )
            .toList();

        if (displayList.isEmpty) {
          return const EmptyState();
        }

        final items = displayList.map((code) {
          final rate = ratesState.rates[code]!;
          return ConvertedCurrency(
            code: code,
            rate: rate,
            converted: prefs.amount * rate,
            isCrypto: isCryptoCurrency(code, rate),
          );
        }).toList();

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(ratesProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return CurrencyCard(
                currency: item,
                baseCurrency: prefs.baseCurrency,
                onRemove: () => ref
                    .read(preferencesProvider.notifier)
                    .removeCurrency(item.code),
              );
            },
          ),
        );
      },
    );
  }
}
