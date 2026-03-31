import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/coinbase_api.dart';
import 'preferences_provider.dart';

final coinbaseApiProvider = Provider((ref) => CoinbaseApi());

class RatesState {
  final Map<String, double> rates;
  final List<String> allCurrencies;

  const RatesState({
    required this.rates,
    required this.allCurrencies,
  });
}

final ratesProvider = FutureProvider<RatesState>((ref) async {
  ref.keepAlive();
  final prefs = await ref.watch(preferencesProvider.future);
  final api = ref.read(coinbaseApiProvider);
  final ratesMap = await api.fetchRates(prefs.baseCurrency);
  return RatesState(
    rates: ratesMap,
    allCurrencies: ratesMap.keys.toList()..sort(),
  );
});
