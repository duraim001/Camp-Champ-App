import '../features/authentication/data/mock_auth_service.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  UserRole? _currentRole;
  String? _currentUserId;
  String? _userName;
  String? _token;

  UserRole? get currentRole => _currentRole;
  String? get currentUserId => _currentUserId;
  String? get userName => _userName;
  String? get token => _token;
  bool get isLoggedIn => _currentRole != null;

  void setUserSession(UserRole role, String userId, {String? name, String? token}) {
    _currentRole = role;
    _currentUserId = userId;
    if (name != null) _userName = name;
    if (token != null) _token = token;
  }

  void setUser({required String role, required String name, required String username, String? token}) {
    UserRole parsedRole = UserRole.teacher;
    switch (role.toLowerCase()) {
      case 'admin':
        parsedRole = UserRole.admin;
        break;
      case 'student':
        parsedRole = UserRole.student;
        break;
      case 'parent':
        parsedRole = UserRole.parent;
        break;
      default:
        parsedRole = UserRole.teacher;
    }
    _currentRole = parsedRole;
    _currentUserId = username;
    _userName = name;
    if (token != null) _token = token;
  }

  void clearSession() {
    _currentRole = null;
    _currentUserId = null;
    _userName = null;
    _token = null;
  }

  bool canAccessAdminRoutes() {
    return _currentRole == UserRole.admin;
  }

  bool canAccessStudentRoutes() {
    return _currentRole == UserRole.student || _currentRole == UserRole.admin;
  }

  bool canAccessTeacherRoutes() {
    return _currentRole == UserRole.teacher || _currentRole == UserRole.admin;
  }

  bool canAccessParentRoutes() {
    return _currentRole == UserRole.parent || _currentRole == UserRole.admin;
  }
}
