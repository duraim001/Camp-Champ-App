import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_sec/core/config/supabase_config.dart';
import 'package:smart_sec/features/authentication/data/mock_auth_service.dart';
import 'package:smart_sec/services/faculty_request_service.dart';
import 'package:smart_sec/services/mock_teacher_service.dart';

class TestHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  HttpOverrides.global = TestHttpOverrides();

  setUpAll(() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  });

  test('Verify Santhipriya HOD is REJECTED from Admin Portal', () async {
    final result = await MockAuthService().login(
      role: UserRole.admin,
      username: 'santhipriyahod@gmail.com',
      password: 'aidshodadmin',
    );
    print('Santhipriya Admin Login Result: $result');
    expect(result['success'], isFalse);
    expect(result['error'], equals('Invalid username or password. Please check your credentials and try again.'));
  });

  test('Verify Mrs. Santhipriya S M.E. HOD SUCCEEDS in Teacher Portal', () async {
    final result = await MockAuthService().login(
      role: UserRole.teacher,
      username: 'santhipriyahod@gmail.com',
      password: 'aidshodadmin',
    );
    print('Santhipriya Teacher Login Result: $result');
    expect(result['success'], isTrue);

    final profile = await MockTeacherService().getTeacherProfile('b244e619-27da-4ccb-9e2f-4380c78fb9c8');
    print('HOD Profile Name: ${profile.name}, ID: ${profile.id}');
    expect(profile.name, equals('Mrs. Santhipriya S M.E.'));
    expect(profile.id, equals('b244e619-27da-4ccb-9e2f-4380c78fb9c8'));
  });

  test('Verify New Faculty Registration creates request routed to Department HOD', () async {
    final submitRes = await FacultyRequestService().submitRequest(
      fullName: 'Test Faculty Member',
      email: 'testfaculty@sengunthar.ac.in',
      phone: '9876543210',
      employeeId: 'SEC-AIDS-TEST01',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Assistant Professor',
      degree: 'M.E.',
      username: 'testfaculty',
      password: 'FacultyPassword123',
    );
    expect(submitRes['success'], isTrue);

    final requests = await FacultyRequestService().fetchRequestsForDepartment('Artificial Intelligence and Data Science');
    print('AI&DS Department Requests Count: ${requests.length}');
    expect(requests.any((r) => r.employeeId == 'SEC-AIDS-TEST01'), isTrue);
  });
}
