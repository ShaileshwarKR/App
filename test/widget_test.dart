import 'package:flutter_test/flutter_test.dart';

import 'package:lifeos/app.dart';

void main() {
  testWidgets('LifeOS app builds', (tester) async {
    await tester.pumpWidget(const LifeOsApp());
    expect(find.text('LifeOS'), findsOneWidget);
  });
}
