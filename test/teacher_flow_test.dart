import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sec/services/faculty_request_service.dart';
import 'package:smart_sec/services/mock_teacher_service.dart';
import 'package:smart_sec/services/session_manager.dart';
import 'package:smart_sec/models/faculty_account_request.dart';
import 'package:smart_sec/features/authentication/data/mock_auth_service.dart';

void main() {
  group('Teacher Flow & Profile Tests', () {
    final facultyService = FacultyRequestService();
    final teacherService = MockTeacherService();

    test('1. Test Faculty One Registration with Degree M.Tech', () async {
      final result = await facultyService.submitRequest(
        fullName: 'Test Faculty One',
        email: 'testfaculty1@example.test',
        phone: '+91 98765 43210',
        employeeId: 'TEST001',
        department: 'Artificial Intelligence and Data Science',
        designation: 'Assistant Professor',
        degree: 'M.Tech',
        username: 'testfaculty1',
        password: 'testpassword',
      );

      expect(result['success'], isTrue);
      final req = result['request'] as FacultyAccountRequestModel;
      expect(req.fullName, equals('Test Faculty One'));
      expect(req.degree, equals('M.Tech'));
      expect(req.designation, equals('Assistant Professor'));
      expect(req.status, equals('PENDING'));
    });

    test('2. PENDING account cannot log in', () async {
      final loginResult = await facultyService.authenticateTeacher(
        username: 'testfaculty1',
        password: 'testpassword',
      );

      expect(loginResult['success'], isFalse);
      expect(loginResult['status'], equals('PENDING'));
    });

    test('3. Admin approves Test Faculty One request', () async {
      final requests = await facultyService.fetchRequests(statusFilter: 'PENDING');
      final target = requests.firstWhere((r) => r.employeeId == 'TEST001');

      final approveResult = await facultyService.approveRequest(
        requestId: target.id,
        adminId: 'ADMIN-001',
      );

      expect(approveResult['success'], isTrue);
    });

    test('4. Test Faculty One logs in successfully after approval', () async {
      final loginResult = await facultyService.authenticateTeacher(
        username: 'testfaculty1',
        password: 'testpassword',
      );

      expect(loginResult['success'], isTrue);
      expect(loginResult['status'], equals('APPROVED'));
      expect(loginResult['userId'], equals('TEST001'));
      expect(loginResult['facultyName'], equals('Test Faculty One'));

      // Simulate session setting
      SessionManager().setUserSession(UserRole.teacher, loginResult['userId']);
      expect(SessionManager().currentUserId, equals('TEST001'));
    });

    test('5. Teacher Profile returns real Test Faculty One details and M.Tech degree', () async {
      final profile = await teacherService.getTeacherProfile('TEST001');

      expect(profile.name, equals('Test Faculty One'));
      expect(profile.designation, equals('Assistant Professor'));
      expect(profile.department, equals('Artificial Intelligence and Data Science'));
      expect(profile.degree, equals('M.Tech'));
      expect(profile.name, isNot(equals('Karthik')));
    });

    test('6. Test Faculty Two Registration with Degree Ph.D.', () async {
      final result = await facultyService.submitRequest(
        fullName: 'Test Faculty Two',
        email: 'testfaculty2@example.test',
        phone: '+91 98765 43211',
        employeeId: 'TEST002',
        department: 'Computer Science & Engineering',
        designation: 'Associate Professor',
        degree: 'Ph.D.',
        username: 'testfaculty2',
        password: 'testpassword2',
      );

      expect(result['success'], isTrue);
      final req = result['request'] as FacultyAccountRequestModel;
      expect(req.fullName, equals('Test Faculty Two'));
      expect(req.degree, equals('Ph.D.'));

      // Admin approves Test Faculty Two
      final approveResult = await facultyService.approveRequest(
        requestId: req.id,
        adminId: 'ADMIN-001',
      );
      expect(approveResult['success'], isTrue);

      // Login as Test Faculty Two
      final loginResult = await facultyService.authenticateTeacher(
        username: 'testfaculty2',
        password: 'testpassword2',
      );
      expect(loginResult['success'], isTrue);

      // Profile verification
      final profile = await teacherService.getTeacherProfile('TEST002');
      expect(profile.name, equals('Test Faculty Two'));
      expect(profile.designation, equals('Associate Professor'));
      expect(profile.degree, equals('Ph.D.'));
      expect(profile.name, isNot(equals('Karthik')));
    });
  });
}
