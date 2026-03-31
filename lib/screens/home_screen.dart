import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/currency_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HeaderSection(),
          Expanded(child: CurrencyList()),
        ],
      ),
    );
  }
}
