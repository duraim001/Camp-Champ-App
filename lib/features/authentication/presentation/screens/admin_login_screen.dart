import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../services/session_manager.dart';
import '../../data/mock_auth_service.dart';
import '../widgets/login_form.dart';

/// AdminLoginScreen renders dedicated login screen for Administrator account.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _adminIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDemoLoggingIn = false;

  @override
  void dispose() {
    _adminIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _populateAndLoginDemo() async {
    setState(() {
      _adminIdController.text = 'SEC-ADM-001';
      _passwordController.text = 'Admin@123';
      _isDemoLoggingIn = true;
    });

    // Simulate login delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Set Admin Role Session BEFORE navigation so authorization guards pass
    SessionManager().setUserSession(UserRole.admin, 'SEC-ADM-001');

    setState(() {
      _isDemoLoggingIn = false;
    });

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.adminDashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.gold),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),

              // Role Badge Icon Container
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: AppColors.gold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 38,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 14),

              // Header Title & Subtitle
              const Text(
                'Admin Login',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Secure access to Camp Champ administration',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),

              // Demo Access Card Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars_rounded, color: AppColors.primaryPurple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'DEMO ACCESS ONLY',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Admin ID: SEC-ADM-001  |  Password: Admin@123',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _isDemoLoggingIn ? null : _populateAndLoginDemo,
                        icon: _isDemoLoggingIn
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryPurple,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.flash_on_rounded, color: AppColors.primaryPurple, size: 18),
                        label: Text(
                          _isDemoLoggingIn ? 'Signing in as Demo Admin...' : 'LOGIN WITH DEMO ACCOUNT',
                          style: const TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Login Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: LoginForm(
                  role: UserRole.admin,
                  usernameLabel: 'Admin ID / Username',
                  usernameController: _adminIdController,
                  passwordController: _passwordController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
