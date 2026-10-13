import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_project/main.dart';

void main() {
  testWidgets('school landing page renders its primary content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Curious minds.\nKind hearts.'), findsOneWidget);
    expect(find.text('Explore learning'), findsOneWidget);
    expect(find.text('Hindustan Standards Bureau'), findsOneWidget);
  });
}
