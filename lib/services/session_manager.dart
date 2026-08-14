import '../features/authentication/data/mock_auth_service.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  UserRole? _currentRole;
  String? _currentUserId;

  UserRole? get currentRole => _currentRole;
  String? get currentUserId => _currentUserId;
  bool get isLoggedIn => _currentRole != null;

  void setUserSession(UserRole role, String userId) {
    _currentRole = role;
    _currentUserId = userId;
  }

  void clearSession() {
    _currentRole = null;
    _currentUserId = null;
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
