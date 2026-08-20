import '../../../services/session_manager.dart';
import '../../../services/faculty_request_service.dart';
import '../../../services/mock_student_service.dart';

enum UserRole {
  admin,
  student,
  teacher,
  parent,
}

extension UserRoleExtension on UserRole {
  String get title {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.parent:
        return 'Parent';
    }
  }

  String get routeName {
    switch (this) {
      case UserRole.admin:
        return '/admin-dashboard';
      case UserRole.student:
        return '/student-dashboard';
      case UserRole.teacher:
        return '/teacher-dashboard';
      case UserRole.parent:
        return '/parent-dashboard';
    }
  }
}

/// MockAuthService simulates authentication logic ready for future Firebase auth plug-in.
class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  /// Authenticate student credentials (Register Number / Roll Number + Date of Birth)
  Future<Map<String, dynamic>> loginStudent({
    required String identifier,
    required String dateOfBirth,
  }) async {
    final trimmedIdentifier = identifier.trim();
    final trimmedDob = dateOfBirth.trim();

    if (trimmedIdentifier.isEmpty || trimmedDob.isEmpty) {
      return {
        'success': false,
        'error': 'Please enter your Register Number/Roll Number and Date of Birth.',
      };
    }

    final authResult = await MockStudentService().authenticateStudent(
      identifier: trimmedIdentifier,
      dateOfBirth: trimmedDob,
    );

    if (authResult['success'] == true) {
      final user = authResult['user'] as Map<String, dynamic>?;
      final regNo = user?['register_number'] ?? trimmedIdentifier;
      SessionManager().setUserSession(UserRole.student, regNo);
      return {'success': true, 'error': null, 'token': authResult['access_token']};
    }

    return authResult;
  }

  /// Authenticate user credentials asynchronously (for Admin, Teacher, Parent).
  Future<Map<String, dynamic>> login({
    required UserRole role,
    required String username,
    required String password,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    final trimmedUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimmedUsername.isEmpty) {
      return {
        'success': false,
        'error': role == UserRole.admin
            ? 'Please enter Admin ID'
            : (role == UserRole.teacher
                ? 'Please enter Teacher ID'
                : (role == UserRole.parent ? 'Please enter Parent ID' : 'Please enter Register Number'))
      };
    }
    if (trimmedPassword.isEmpty) {
      return {'success': false, 'error': 'Please enter password'};
    }

    // Admin Demo Check
    if (role == UserRole.admin) {
      if ((trimmedUsername == 'SEC-ADM-001' || trimmedUsername == 'admin@smartsec.demo') && trimmedPassword == 'Admin@123') {
        SessionManager().setUserSession(UserRole.admin, trimmedUsername);
        return {'success': true, 'error': null};
      } else if (trimmedUsername == 'santhipriyahod@gmail.com' && trimmedPassword == 'aidshodadmin') {
        SessionManager().setUserSession(UserRole.admin, trimmedUsername);
        return {'success': true, 'error': null};
      } else {
        return {'success': false, 'error': 'Invalid credentials. Use santhipriyahod@gmail.com & Password: aidshodadmin or SEC-ADM-001 & Admin@123'};
      }
    }

    // Teacher Login & Status Check
    if (role == UserRole.teacher) {
      final lowerUser = trimmedUsername.toLowerCase();
      final isDemoTeacher = lowerUser == 'sec-tch-001' ||
          lowerUser == 'teacher@smartsec.demo' ||
          lowerUser == 'karthik@smartsec.demo' ||
          lowerUser == 'teacher';
      final isDemoPassword = trimmedPassword == 'Teacher@123' ||
          trimmedPassword == 'teacher123' ||
          trimmedPassword == 'Teacher123';

      if (isDemoTeacher && isDemoPassword) {
        SessionManager().setUserSession(UserRole.teacher, 'SEC-TCH-001');
        return {'success': true, 'error': null};
      }

      // Check registered faculty account request status first
      final facultyAuth = await FacultyRequestService().authenticateTeacher(
        username: trimmedUsername,
        password: trimmedPassword,
      );

      if (facultyAuth['success'] == true) {
        final userId = facultyAuth['userId'] ?? trimmedUsername;
        SessionManager().setUserSession(UserRole.teacher, userId);
        return {'success': true, 'error': null};
      } else if (facultyAuth['status'] != null) {
        // Return status-specific error (PENDING, REJECTED)
        return {'success': false, 'error': facultyAuth['error']};
      }

      return {
        'success': false,
        'error': facultyAuth['error'] ??
            'Invalid teacher credentials. Use Teacher ID: SEC-TCH-001 & Password: Teacher@123'
      };
    }

    // Parent Demo Check
    if (role == UserRole.parent) {
      if (trimmedUsername == 'SEC-PAR-001' && trimmedPassword == 'Parent@123') {
        SessionManager().setUserSession(UserRole.parent, 'SEC-PAR-001');
        return {'success': true, 'error': null};
      } else {
        return {'success': false, 'error': 'Invalid demo credentials. Use Parent ID: SEC-PAR-001 & Password: Parent@123'};
      }
    }

    SessionManager().setUserSession(role, trimmedUsername);
    return {'success': true, 'error': null};
  }
}

