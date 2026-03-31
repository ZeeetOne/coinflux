import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coinflux/app.dart';

void main() {
  testWidgets('App renders header title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CoinFluxApp()),
    );

    expect(find.text('Fiat & Crypto Rates'), findsOneWidget);
  });
}
