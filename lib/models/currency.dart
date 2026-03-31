import 'package:intl/intl.dart';

const kDefaultBase = 'USD';
const kDefaultWatchlist = ['IDR', 'EUR', 'GBP', 'JPY', 'BTC', 'ETH', 'SOL'];
const kPriorityList = [
  'USD', 'IDR', 'EUR', 'GBP', 'JPY', 'BTC', 'ETH', 'SOL', 'DOGE', 'USDT'
];
const kKnownCrypto = {'BTC', 'ETH', 'SOL', 'USDT', 'DOGE', 'ADA', 'XRP'};

class ConvertedCurrency {
  final String code;
  final double rate;
  final double converted;
  final bool isCrypto;

  const ConvertedCurrency({
    required this.code,
    required this.rate,
    required this.converted,
    required this.isCrypto,
  });
}

bool isCryptoCurrency(String code, double rate) {
  return kKnownCrypto.contains(code) ||
      (rate < 0.01 && !{'IDR', 'VND'}.contains(code));
}

String formatNumber(double num) {
  if (num == 0) return '0';
  if (num < 0.000001) return num.toStringAsFixed(8);
  if (num < 0.01) return num.toStringAsFixed(6);
  if (num < 100) {
    return NumberFormat('#,##0.####', 'en_US').format(num);
  }
  return NumberFormat('#,##0.##', 'en_US').format(num);
}
