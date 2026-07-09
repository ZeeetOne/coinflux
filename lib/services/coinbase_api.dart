import 'package:dio/dio.dart';

class CoinbaseApi {
  final Dio _dio;

  CoinbaseApi([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    try {
      final response = await _dio.get(
        'https://api.coinbase.com/v2/exchange-rates',
        queryParameters: {'currency': baseCurrency},
      );
      final rates =
          response.data['data']['rates'] as Map<String, dynamic>;
      return rates.map((k, v) => MapEntry(k, double.parse(v.toString())));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit reached. Please wait a moment.');
      }
      throw Exception('Failed to fetch rates: ${e.message}');
    } on FormatException {
      throw Exception('Unexpected response format from server.');
    }
  }

  Future<Map<String, String>> fetchCurrencyNames() async {
    final responses = await Future.wait([
      _dio.get('https://api.coinbase.com/v2/currencies'),
      _dio.get('https://api.coinbase.com/v2/currencies/crypto'),
    ]);

    final fiat = (responses[0].data['data'] as List).cast<Map<String, dynamic>>();
    final crypto = (responses[1].data['data'] as List).cast<Map<String, dynamic>>();

    final names = <String, String>{};
    for (final c in fiat) {
      names[c['id'] as String] = c['name'] as String;
    }
    for (final c in crypto) {
      names[c['code'] as String] = c['name'] as String;
    }
    return names;
  }
}
