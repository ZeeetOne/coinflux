import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class AppPreferences {
  final String baseCurrency;
  final List<String> watchlist;
  final double amount;

  const AppPreferences({
    this.baseCurrency = kDefaultBase,
    this.watchlist = const [],
    this.amount = 1.0,
  });

  AppPreferences copyWith({
    String? baseCurrency,
    List<String>? watchlist,
    double? amount,
  }) {
    return AppPreferences(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      watchlist: watchlist ?? this.watchlist,
      amount: amount ?? this.amount,
    );
  }
}

class PreferencesNotifier extends AsyncNotifier<AppPreferences> {
  @override
  Future<AppPreferences> build() async {
    final storage = ref.read(storageServiceProvider);
    final base = await storage.getBaseCurrency() ?? kDefaultBase;
    final watchlist = await storage.getWatchlist() ?? kDefaultWatchlist;
    return AppPreferences(baseCurrency: base, watchlist: watchlist);
  }

  Future<void> setBaseCurrency(String code) async {
    final current = state.asData?.value;
    if (current == null) return;

    var watchlist = List<String>.from(current.watchlist);
    watchlist.remove(code);

    final newState = current.copyWith(baseCurrency: code, watchlist: watchlist);
    state = AsyncData(newState);

    final storage = ref.read(storageServiceProvider);
    await storage.setBaseCurrency(code);
    await storage.setWatchlist(watchlist);
  }

  Future<void> toggleWatchlistCurrency(String code) async {
    final current = state.asData?.value;
    if (current == null || code == current.baseCurrency) return;

    var watchlist = List<String>.from(current.watchlist);
    if (watchlist.contains(code)) {
      watchlist.remove(code);
    } else {
      watchlist.add(code);
    }

    state = AsyncData(current.copyWith(watchlist: watchlist));
    await ref.read(storageServiceProvider).setWatchlist(watchlist);
  }

  Future<void> removeCurrency(String code) async {
    final current = state.asData?.value;
    if (current == null) return;

    var watchlist = List<String>.from(current.watchlist);
    watchlist.remove(code);

    state = AsyncData(current.copyWith(watchlist: watchlist));
    await ref.read(storageServiceProvider).setWatchlist(watchlist);
  }

  void setAmount(double amount) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(amount: amount));
  }
}

final preferencesProvider =
    AsyncNotifierProvider<PreferencesNotifier, AppPreferences>(
  PreferencesNotifier.new,
);
