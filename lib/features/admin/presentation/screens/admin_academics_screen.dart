import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminAcademicsScreen extends StatelessWidget {
  const AdminAcademicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> programs = [
      {'name': 'B.E. Computer Science & Engineering', 'code': 'CSE', 'students': '480 Students', 'duration': '4 Years'},
      {'name': 'B.Tech Information Technology', 'code': 'IT', 'students': '360 Students', 'duration': '4 Years'},
      {'name': 'B.Tech Artificial Intelligence & Data Science', 'code': 'AI&DS', 'students': '240 Students', 'duration': '4 Years'},
      {'name': 'B.E. Electronics & Communication Engg.', 'code': 'ECE', 'students': '420 Students', 'duration': '4 Years'},
      {'name': 'B.E. Electrical & Electronics Engg.', 'code': 'EEE', 'students': '300 Students', 'duration': '4 Years'},
      {'name': 'B.E. Mechanical Engineering', 'code': 'MECH', 'students': '320 Students', 'duration': '4 Years'},
      {'name': 'B.E. Civil Engineering', 'code': 'CIVIL', 'students': '180 Students', 'duration': '4 Years'},
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.school_rounded, color: AppColors.gold, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Management',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Degree Programs, Syllabus & Master Curriculum',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Academic Stats Row
              Row(
                children: [
                  Expanded(child: _buildMetricCard('Degree Programs', '7 Courses', Icons.collections_bookmark_rounded, AppColors.primaryPurple)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMetricCard('Current Semester', 'Even (2026)', Icons.calendar_month_rounded, AppColors.gold)),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Department Academic Offerings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 12),

              ...programs.map((p) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                        child: Text(
                          p['code']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                      title: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('${p['duration']} • ${p['students']}', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}
