// Basic smoke test for the Egypt Explorer app.

import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Home screen renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EgyptExplorerApp());

    // Verify the home screen title and buttons are present.
    expect(find.text('Welcome to Egypt Explorer'), findsOneWidget);
    expect(find.text('Explore Tourist Places'), findsOneWidget);
    expect(find.text('Earthquake Explorer'), findsOneWidget);
  });
}
