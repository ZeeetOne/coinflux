import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Your list is empty.\nTap "Add Asset" above to select which rates you want to see.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
