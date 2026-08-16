import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../services/session_manager.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Parent Profile'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.gold),
            tooltip: 'Logout',
            onPressed: () {
              SessionManager().clearSession();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginSelection,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Avatar & Basic Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPurple.withValues(alpha: 0.1),
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: const Icon(
                            Icons.family_restroom_outlined,
                            size: 46,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: AppColors.primaryPurple,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Mr. Kumar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Parent ID: SEC-PAR-001  •  Relationship: Father',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Info Section
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(Icons.phone_rounded, 'Primary Phone', '+91 90000 00003'),
                    const Divider(height: 20),
                    _buildProfileItem(Icons.contact_phone_rounded, 'Emergency Contact', '+91 90000 00099'),
                    const Divider(height: 20),
                    _buildProfileItem(Icons.email_rounded, 'Email Address', 'parent.demo@campchamp.demo'),
                    const Divider(height: 20),
                    _buildProfileItem(Icons.location_on_rounded, 'Residential Address', 'No. 42, Main Road, Tiruchengode, Tamil Nadu'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Linked Children Section
              _buildSectionHeader('Linked Children'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      Icons.school_rounded,
                      'Child 1',
                      'Arun Kumar (Register No: SEC2024001)',
                      subtitle: 'B.E. Computer Science — 3rd Year (Section A)',
                    ),
                    const Divider(height: 20),
                    _buildProfileItem(
                      Icons.account_balance_rounded,
                      'Institution',
                      'Sengunthar Engineering College',
                      subtitle: 'Tiruchengode, Tamil Nadu',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    SessionManager().clearSession();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.loginSelection,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.white),
                  label: const Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
