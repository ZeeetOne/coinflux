import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rates_provider.dart';

class StatusIndicator extends ConsumerWidget {
  const StatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(ratesProvider);

    return rates.when(
      loading: () => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Fetching live rates...',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      error: (_, _) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
          SizedBox(width: 8),
          Text(
            'Error loading rates',
            style: TextStyle(fontSize: 12, color: Colors.redAccent),
          ),
        ],
      ),
      data: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: Colors.green[300]),
          const SizedBox(width: 8),
          Text(
            'Updated live via Coinbase',
            style: TextStyle(fontSize: 12, color: Colors.indigo[200]),
          ),
        ],
      ),
    );
  }
}
