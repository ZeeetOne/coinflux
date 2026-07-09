import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'preferences_provider.dart';
import 'rates_provider.dart';

class CurrencyNamesNotifier extends AsyncNotifier<Map<String, String>> {
  @override
  Future<Map<String, String>> build() async {
    ref.keepAlive();
    final storage = ref.read(storageServiceProvider);
    final api = ref.read(coinbaseApiProvider);

    try {
      final names = await api.fetchCurrencyNames();
      await storage.setCurrencyNames(names);
      return names;
    } catch (_) {
      return await storage.getCurrencyNames() ?? {};
    }
  }
}

final currencyNamesProvider =
    AsyncNotifierProvider<CurrencyNamesNotifier, Map<String, String>>(
  CurrencyNamesNotifier.new,
);
