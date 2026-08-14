import '../../../services/session_manager.dart';

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

  /// Authenticate user credentials asynchronously.
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
      } else {
        return {'success': false, 'error': 'Invalid demo credentials. Use Admin ID: SEC-ADM-001 & Password: Admin@123'};
      }
    }

    // Student Demo Check
    if (role == UserRole.student) {
      if (trimmedUsername == 'SEC2024001' && trimmedPassword == 'Student@123') {
        SessionManager().setUserSession(UserRole.student, 'SEC2024001');
        return {'success': true, 'error': null};
      } else {
        return {'success': false, 'error': 'Invalid demo credentials. Use Register Number: SEC2024001 & Password: Student@123'};
      }
    }

    // Teacher Demo Check
    if (role == UserRole.teacher) {
      if (trimmedUsername == 'SEC-TCH-001' && trimmedPassword == 'Teacher@123') {
        SessionManager().setUserSession(UserRole.teacher, 'SEC-TCH-001');
        return {'success': true, 'error': null};
      } else {
        return {'success': false, 'error': 'Invalid demo credentials. Use Teacher ID: SEC-TCH-001 & Password: Teacher@123'};
      }
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
