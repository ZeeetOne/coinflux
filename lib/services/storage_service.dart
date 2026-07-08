import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _baseCurrencyKey = 'baseCurrency';
  static const _watchlistKey = 'myCurrencies';
  static const _themeModeKey = 'themeMode';

  Future<String?> getBaseCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseCurrencyKey);
  }

  Future<void> setBaseCurrency(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseCurrencyKey, code);
  }

  Future<List<String>?> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_watchlistKey);
  }

  Future<void> setWatchlist(List<String> codes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_watchlistKey, codes);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }
}
