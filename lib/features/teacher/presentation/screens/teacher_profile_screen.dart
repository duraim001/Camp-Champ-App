import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../models/teacher.dart';
import '../../../../services/mock_teacher_service.dart';
import '../../../../services/session_manager.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  TeacherModel? _teacher;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = SessionManager().currentUserId ?? 'SEC-TCH-001';
    final profile = await MockTeacherService().getTeacherProfile(userId);
    if (mounted) {
      setState(() {
        _teacher = profile;
        _isLoading = false;
      });
    }
  }

  void _handleLogout(BuildContext context) {
    SessionManager().clearSession();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginSelection,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('Teacher Profile'),
          backgroundColor: AppColors.primaryPurple,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
      );
    }

    final teacher = _teacher ?? const TeacherModel(
      id: 'SEC-TCH-001',
      name: 'Faculty Member',
      facultyId: 'SEC-TCH-001',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Assistant Professor',
      degree: 'M.Tech',
      subjects: ['Data Structures'],
      email: 'faculty@sengunthar.ac.in',
      phone: '+91 90000 00002',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Header Card
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
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryPurple,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.gold,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      teacher.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${teacher.designation} • ${teacher.degree}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        teacher.department,
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Faculty Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.badge_rounded, color: AppColors.primaryPurple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Faculty Information',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildRow('Teacher ID', teacher.facultyId),
                    _buildRow('Qualification / Degree', teacher.degree),
                    _buildRow('Department', teacher.department),
                    _buildRow('Designation', teacher.designation),
                    _buildRow('Class Advisor', teacher.classAdvisor),
                    _buildRow('Assigned Subjects', teacher.subjects.join(', ')),
                    _buildRow('Email', teacher.email),
                    _buildRow('Phone', teacher.phone),
                    _buildRow('Institution', teacher.college),
                    _buildRow('Location', teacher.location),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    'LOGOUT FROM FACULTY PORTAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
