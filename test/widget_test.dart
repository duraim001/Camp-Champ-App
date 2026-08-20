import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sec/main.dart';

void main() {
  testWidgets('Camp Champ app loads welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartSecApp());
    await tester.pumpAndSettle();

    // Verify that institutional branding text exists.
    expect(find.textContaining('SENGUNTHAR ENGINEERING COLLEGE'), findsOneWidget);
  });
}

