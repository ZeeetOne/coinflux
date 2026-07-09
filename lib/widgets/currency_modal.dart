import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../providers/currency_names_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/rates_provider.dart';
import '../theme/app_theme.dart';

enum ModalMode { base, target }

class CurrencyModal extends ConsumerStatefulWidget {
  final ModalMode mode;

  const CurrencyModal({super.key, required this.mode});

  @override
  ConsumerState<CurrencyModal> createState() => _CurrencyModalState();
}

class _CurrencyModalState extends ConsumerState<CurrencyModal> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _buildSortedList(
    List<String> allCurrencies,
    Map<String, String> names,
  ) {
    if (_searchTerm.isNotEmpty) {
      final term = _searchTerm.toLowerCase();
      return allCurrencies.where((c) {
        final name = names[c]?.toLowerCase() ?? '';
        return c.toLowerCase().contains(term) || name.contains(term);
      }).toList();
    }
    final priority =
        kPriorityList.where((c) => allCurrencies.contains(c)).toList();
    final rest = allCurrencies.where((c) => !kPriorityList.contains(c)).toList()
      ..sort();
    return [...priority, ...rest];
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider).asData?.value;
    final ratesAsync = ref.watch(ratesProvider);
    final allCurrencies = ratesAsync.asData?.value.allCurrencies ?? [];
    final names = ref.watch(currencyNamesProvider).asData?.value ?? {};

    final isBase = widget.mode == ModalMode.base;
    final title = isBase ? 'Select Base Currency' : 'Add Fiat or Crypto';

    final sortedList = _buildSortedList(allCurrencies, names);
    final theme = Theme.of(context);
    final cfColors = theme.extension<CoinFluxColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: cfColors.headerGradient,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (v) => setState(() => _searchTerm = v),
              decoration: InputDecoration(
                hintText: 'Search asset (e.g. BTC, ETH, IDR)...',
                hintStyle: TextStyle(fontSize: 14, color: cfColors.textMuted),
                prefixIcon: Icon(Icons.search, color: cfColors.textMuted),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final currency = sortedList[index];

                if (isBase) {
                  return _BaseItem(
                    code: currency,
                    name: names[currency],
                    isSelected: currency == prefs?.baseCurrency,
                    onTap: () {
                      ref
                          .read(preferencesProvider.notifier)
                          .setBaseCurrency(currency);
                      Navigator.pop(context);
                    },
                  );
                } else {
                  if (currency == prefs?.baseCurrency) {
                    return const SizedBox.shrink();
                  }
                  return _TargetItem(
                    code: currency,
                    name: names[currency],
                    isSelected: prefs?.watchlist.contains(currency) ?? false,
                    onTap: () => ref
                        .read(preferencesProvider.notifier)
                        .toggleWatchlistCurrency(currency),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseItem extends StatelessWidget {
  final String code;
  final String? name;
  final bool isSelected;
  final VoidCallback onTap;

  const _BaseItem({
    required this.code,
    this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = code.length > 4 ? '${code.substring(0, 3)}..' : code;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        currencyLabel(code, name),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
    );
  }
}

class _TargetItem extends StatelessWidget {
  final String code;
  final String? name;
  final bool isSelected;
  final VoidCallback onTap;

  const _TargetItem({
    required this.code,
    this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = code.length > 4 ? '${code.substring(0, 3)}..' : code;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        currencyLabel(code, name),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : Icon(Icons.add, color: colorScheme.onSurfaceVariant),
    );
  }
}
