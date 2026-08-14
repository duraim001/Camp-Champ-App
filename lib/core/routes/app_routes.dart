import 'package:flutter/material.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/authentication/presentation/screens/access_denied_screen.dart';
import '../../features/authentication/presentation/screens/admin_login_screen.dart';
import '../../features/authentication/presentation/screens/login_selection_screen.dart';
import '../../features/authentication/presentation/screens/parent_login_screen.dart';
import '../../features/authentication/presentation/screens/student_login_screen.dart';
import '../../features/authentication/presentation/screens/teacher_login_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/parent/presentation/screens/parent_dashboard_screen.dart';
import '../../features/student/presentation/screens/student_dashboard_screen.dart';
import '../../features/teacher/presentation/screens/teacher_dashboard_screen.dart';
import '../../services/session_manager.dart';

/// AppRoutes defines centralized route names and route generator for Smart SEC.
abstract class AppRoutes {
  static const String welcome = '/';
  static const String loginSelection = '/login-selection';
  static const String adminLogin = '/admin-login';
  static const String studentLogin = '/student-login';
  static const String teacherLogin = '/teacher-login';
  static const String parentLogin = '/parent-login';
  static const String adminDashboard = '/admin-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String parentDashboard = '/parent-dashboard';
  static const String accessDenied = '/access-denied';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case welcome:
        page = const WelcomeScreen();
        break;
      case loginSelection:
        page = const LoginSelectionScreen();
        break;
      case adminLogin:
        page = const AdminLoginScreen();
        break;
      case studentLogin:
        page = const StudentLoginScreen();
        break;
      case teacherLogin:
        page = const TeacherLoginScreen();
        break;
      case parentLogin:
        page = const ParentLoginScreen();
        break;
      case adminDashboard:
        // Role-Based Authorization Guard: Only Admin can access Admin Dashboard
        if (!SessionManager().canAccessAdminRoutes()) {
          page = const AccessDeniedScreen();
        } else {
          page = const AdminDashboardScreen();
        }
        break;
      case studentDashboard:
        page = const StudentDashboardScreen();
        break;
      case teacherDashboard:
        // Role-Based Authorization Guard: Only Teacher or Admin can access Teacher Dashboard
        if (!SessionManager().canAccessTeacherRoutes()) {
          page = const AccessDeniedScreen();
        } else {
          page = const TeacherDashboardScreen();
        }
        break;
      case parentDashboard:
        page = const ParentDashboardScreen();
        break;
      case accessDenied:
        page = const AccessDeniedScreen();
        break;
      default:
        page = const WelcomeScreen();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
