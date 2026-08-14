import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/role_login_card.dart';

/// LoginSelectionScreen allows users to choose their login role.
class LoginSelectionScreen extends StatelessWidget {
  const LoginSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Smart SEC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.gold),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),

              // Welcome Title
              const Text(
                'Welcome to Smart SEC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),

              // Official Tagline Subtitle
              const Text(
                'One Campus, One Platform, One Connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 14),

              // Instruction Text
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.5),
                  ),
                ),
                child: const Text(
                  'Select your account type to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2 x 2 Responsive Grid for Login Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
                children: [
                  // 1. ADMIN LOGIN CARD
                  RoleLoginCard(
                    title: 'ADMIN LOGIN',
                    description:
                        'Manage campus operations and academic administration',
                    icon: Icons.admin_panel_settings_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.adminLogin);
                    },
                  ),

                  // 2. TEACHER LOGIN CARD
                  RoleLoginCard(
                    title: 'TEACHER LOGIN',
                    description:
                        'Manage classes, attendance, marks and activities',
                    icon: Icons.badge_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.teacherLogin);
                    },
                  ),

                  // 3. PARENT LOGIN CARD
                  RoleLoginCard(
                    title: 'PARENT LOGIN',
                    description:
                        "Monitor your child's academic progress & updates",
                    icon: Icons.family_restroom_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.parentLogin);
                    },
                  ),

                  // 4. STUDENT LOGIN CARD
                  RoleLoginCard(
                    title: 'STUDENT LOGIN',
                    description:
                        'Access academics, attendance, exams & services',
                    icon: Icons.school_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.studentLogin);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Bottom Campus Identity Footer
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
      ),
    );
  }
}
