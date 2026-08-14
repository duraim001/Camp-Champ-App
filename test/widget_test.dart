import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sec/main.dart';

void main() {
  testWidgets('Smart SEC app loads welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartSecApp());

    // Verify that title text exists.
    expect(find.textContaining('SMART COLLEGE'), findsOneWidget);
  });
}
