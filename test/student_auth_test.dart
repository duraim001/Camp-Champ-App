import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sec/features/authentication/data/mock_auth_service.dart';
import 'package:smart_sec/services/session_manager.dart';

void main() {
  setUp(() {
    SessionManager().clearSession();
  });

  group('Student Authentication Tests', () {
    test('TEST 1 — VALID REGISTER NUMBER (SEC2024001 + 15/06/2005)', () async {
      final result = await MockAuthService().loginStudent(
        identifier: 'SEC2024001',
        dateOfBirth: '15/06/2005',
      );
      expect(result['success'], isTrue);
      expect(result['error'], isNull);
      expect(SessionManager().currentRole, equals(UserRole.student));
      expect(SessionManager().currentUserId, equals('SEC2024001'));
    });

    test('TEST 1 (Alternative) — VALID REGISTER NUMBER (23AIDS001 + 15/06/2005)', () async {
      final result = await MockAuthService().loginStudent(
        identifier: '23AIDS001',
        dateOfBirth: '15/06/2005',
      );
      expect(result['success'], isTrue);
      expect(result['error'], isNull);
      expect(SessionManager().currentRole, equals(UserRole.student));
      expect(SessionManager().currentUserId, equals('23AIDS001'));
    });

    test('TEST 2 — VALID ROLL NUMBER (01 + 15/06/2005)', () async {
      final result = await MockAuthService().loginStudent(
        identifier: '01',
        dateOfBirth: '15/06/2005',
      );
      expect(result['success'], isTrue);
      expect(result['error'], isNull);
      expect(SessionManager().currentRole, equals(UserRole.student));
    });

    test('TEST 3 — WRONG REGISTER NUMBER', () async {
      final result = await MockAuthService().loginStudent(
        identifier: 'INVALID_REG_999',
        dateOfBirth: '15/06/2005',
      );
      expect(result['success'], isFalse);
      expect(result['error'], equals('Invalid Register Number/Roll Number or Date of Birth.'));
      expect(SessionManager().isLoggedIn, isFalse);
    });

    test('TEST 4 — WRONG DOB', () async {
      final result = await MockAuthService().loginStudent(
        identifier: 'SEC2024001',
        dateOfBirth: '01/01/2000',
      );
      expect(result['success'], isFalse);
      expect(result['error'], equals('Invalid Register Number/Roll Number or Date of Birth.'));
      expect(SessionManager().isLoggedIn, isFalse);
    });

    test('TEST 5 — EMPTY FIELDS', () async {
      final resultEmptyBoth = await MockAuthService().loginStudent(
        identifier: '',
        dateOfBirth: '',
      );
      expect(resultEmptyBoth['success'], isFalse);
      expect(resultEmptyBoth['error'], equals('Please enter your Register Number/Roll Number and Date of Birth.'));

      final resultEmptyDob = await MockAuthService().loginStudent(
        identifier: 'SEC2024001',
        dateOfBirth: '',
      );
      expect(resultEmptyDob['success'], isFalse);
      expect(resultEmptyDob['error'], equals('Please enter your Register Number/Roll Number and Date of Birth.'));
    });

    test('TEST 6 — INACTIVE STUDENT', () async {
      final result = await MockAuthService().loginStudent(
        identifier: 'SEC2024010',
        dateOfBirth: '19/10/2005',
      );
      expect(result['success'], isFalse);
      expect(result['error'], equals('Your account is currently inactive. Please contact the administrator.'));
      expect(SessionManager().isLoggedIn, isFalse);
    });

    test('TEST 7 — OTHER ROLES (Admin, Teacher, Parent unchanged)', () async {
      // Admin Login
      final adminResult = await MockAuthService().login(
        role: UserRole.admin,
        username: 'SEC-ADM-001',
        password: 'Admin@123',
      );
      expect(adminResult['success'], isTrue);
      expect(SessionManager().currentRole, equals(UserRole.admin));

      // Teacher Login
      final teacherResult = await MockAuthService().login(
        role: UserRole.teacher,
        username: 'SEC-TCH-001',
        password: 'Teacher@123',
      );
      expect(teacherResult['success'], isTrue);
      expect(SessionManager().currentRole, equals(UserRole.teacher));

      // Parent Login
      final parentResult = await MockAuthService().login(
        role: UserRole.parent,
        username: 'SEC-PAR-001',
        password: 'Parent@123',
      );
      expect(parentResult['success'], isTrue);
      expect(SessionManager().currentRole, equals(UserRole.parent));
    });
  });
}
