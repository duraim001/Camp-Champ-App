import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

/// LoginSelectionScreen presents a modern, minimal role selection onboarding screen.
class LoginSelectionScreen extends StatefulWidget {
  const LoginSelectionScreen({super.key});

  @override
  State<LoginSelectionScreen> createState() => _LoginSelectionScreenState();
}

class _LoginSelectionScreenState extends State<LoginSelectionScreen> {
  String? _selectedRole;

  void _navigateToSelectedRoleLogin() {
    if (_selectedRole == null) return;

    switch (_selectedRole) {
      case 'Student':
        Navigator.pushNamed(context, AppRoutes.studentLogin);
        break;
      case 'Teacher':
        Navigator.pushNamed(context, AppRoutes.teacherLogin);
        break;
      case 'Parent':
        Navigator.pushNamed(context, AppRoutes.parentLogin);
        break;
      case 'Admin':
        Navigator.pushNamed(context, AppRoutes.adminLogin);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNextEnabled = _selectedRole != null;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Camp Champ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Welcoming Title
                    const Text(
                      'Who are you?',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    const Text(
                      'Select your role to continue',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 1. STUDENT OPTION
                    _buildRoleOptionTile(
                      roleName: 'Student',
                      icon: Icons.school_rounded,
                    ),
                    const SizedBox(height: 12),

                    // 2. TEACHER OPTION
                    _buildRoleOptionTile(
                      roleName: 'Teacher',
                      icon: Icons.badge_rounded,
                    ),
                    const SizedBox(height: 12),

                    // 3. PARENT OPTION
                    _buildRoleOptionTile(
                      roleName: 'Parent',
                      icon: Icons.family_restroom_rounded,
                    ),
                    const SizedBox(height: 12),

                    // 4. ADMIN OPTION
                    _buildRoleOptionTile(
                      roleName: 'Admin',
                      icon: Icons.admin_panel_settings_rounded,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // BOTTOM NEXT BUTTON CONTAINER
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isNextEnabled ? _navigateToSelectedRoleLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        disabledBackgroundColor: AppColors.primaryPurple.withValues(alpha: 0.3),
                        elevation: isNextEnabled ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isNextEnabled ? AppColors.gold : AppColors.white.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sengunthar Engineering College • Tiruchengode',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOptionTile({
    required String roleName,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == roleName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryPurple.withValues(alpha: 0.08)
            : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryPurple
              : AppColors.primaryPurple.withValues(alpha: 0.12),
          width: isSelected ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primaryPurple.withValues(alpha: 0.08)
                : AppColors.primaryPurple.withValues(alpha: 0.03),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedRole = roleName;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPurple
                        : AppColors.primaryPurple.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.gold : AppColors.primaryPurple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Role Name
                Expanded(
                  child: Text(
                    roleName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? AppColors.primaryPurple : AppColors.darkText,
                    ),
                  ),
                ),

                // Selection Radio Checkmark Indicator
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.secondaryText.withValues(alpha: 0.5),
                      width: isSelected ? 0 : 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.gold,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
