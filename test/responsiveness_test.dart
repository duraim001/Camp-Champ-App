import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sec/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/login_selection_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/student_login_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/teacher_login_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/admin_login_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/parent_login_screen.dart';
import 'package:smart_sec/features/authentication/presentation/screens/faculty_registration_screen.dart';
import 'package:smart_sec/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:smart_sec/features/teacher/presentation/screens/teacher_dashboard_screen.dart';
import 'package:smart_sec/features/student/presentation/screens/student_dashboard_screen.dart';
import 'package:smart_sec/features/parent/presentation/screens/parent_dashboard_screen.dart';

void main() {
  const viewports = <String, Size>{
    'Small Phone (320x568)': Size(320, 568),
    'Compact Phone (360x640)': Size(360, 640),
    'Standard Modern Phone (390x844)': Size(390, 844),
    'Tall Phone (360x800)': Size(360, 800),
    'Large Pro Max Phone (430x932)': Size(430, 932),
    'Landscape Mode (800x360)': Size(800, 360),
  };

  Widget buildTestableWidget(Widget child, Size size) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: const EdgeInsets.only(top: 24, bottom: 16),
          viewInsets: EdgeInsets.zero,
          devicePixelRatio: 2.0,
        ),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        ),
      ),
    );
  }

  for (final entry in viewports.entries) {
    final deviceName = entry.key;
    final size = entry.value;

    group('Responsiveness on $deviceName', () {
      testWidgets('WelcomeScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const WelcomeScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('LoginSelectionScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const LoginSelectionScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('StudentLoginScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const StudentLoginScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('TeacherLoginScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const TeacherLoginScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('AdminLoginScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const AdminLoginScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('ParentLoginScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const ParentLoginScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('FacultyRegistrationScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const FacultyRegistrationScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('AdminDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const AdminDashboardScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('TeacherDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const TeacherDashboardScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('StudentDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const StudentDashboardScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('ParentDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size * 2.0;
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(buildTestableWidget(const ParentDashboardScreen(), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });
  }
}
