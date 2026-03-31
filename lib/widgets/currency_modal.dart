import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../providers/preferences_provider.dart';
import '../providers/rates_provider.dart';

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

  List<String> _buildSortedList(List<String> allCurrencies) {
    if (_searchTerm.isNotEmpty) {
      return allCurrencies
          .where((c) => c.contains(_searchTerm.toUpperCase()))
          .toList();
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

    final isBase = widget.mode == ModalMode.base;
    final title = isBase ? 'Select Base Currency' : 'Add Fiat or Crypto';

    final sortedList = _buildSortedList(allCurrencies);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF4338CA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
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
  final bool isSelected;
  final VoidCallback onTap;

  const _BaseItem({
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = code.length > 4 ? '${code.substring(0, 3)}..' : code;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected
            ? const Color(0xFF7C3AED)
            : Colors.grey[100],
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
      title: Text(
        code,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? const Color(0xFF6D28D9) : Colors.grey[800],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF7C3AED))
          : null,
    );
  }
}

class _TargetItem extends StatelessWidget {
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _TargetItem({
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = code.length > 4 ? '${code.substring(0, 3)}..' : code;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected
            ? const Color(0xFF4338CA)
            : Colors.grey[100],
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
      title: Text(
        code,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF4338CA))
          : const Icon(Icons.add, color: Colors.grey),
    );
  }
}
