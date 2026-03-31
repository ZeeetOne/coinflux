import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class CoinFluxApp extends StatelessWidget {
  const CoinFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinFlux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4338CA), // indigo-700
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB), // gray-50
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
