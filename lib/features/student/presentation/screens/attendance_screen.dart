import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_student_service.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = MockStudentService().getDemoStudentProfile();

    final List<Map<String, dynamic>> subjectAttendance = [
      {'subject': 'Data Structures', 'present': 38, 'absent': 4, 'percentage': 90.0},
      {'subject': 'Database Systems', 'present': 35, 'absent': 5, 'percentage': 87.5},
      {'subject': 'Operating Systems', 'present': 34, 'absent': 6, 'percentage': 85.0},
      {'subject': 'Computer Networks', 'present': 37, 'absent': 3, 'percentage': 92.5},
      {'subject': 'Software Engineering', 'present': 36, 'absent': 4, 'percentage': 90.0},
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Attendance'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Attendance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'OVERALL ATTENDANCE',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: student.attendancePercentage / 100.0,
                            backgroundColor: AppColors.lightBackground,
                            color: AppColors.primaryPurple,
                            strokeWidth: 10,
                          ),
                        ),
                        Text(
                          '${student.attendancePercentage}%',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAttendanceStatusBadge(student.attendancePercentage),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'SUBJECT-WISE ATTENDANCE',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),

              // Subject Attendance List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjectAttendance.length,
                itemBuilder: (context, index) {
                  final item = subjectAttendance[index];
                  final double pct = item['percentage'];
                  final int total = (item['present'] as int) + (item['absent'] as int);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['subject'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              Text(
                                '$pct%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: pct >= 85
                                      ? Colors.green.shade800
                                      : (pct >= 75 ? Colors.orange.shade800 : Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: pct / 100.0,
                              minHeight: 8,
                              backgroundColor: AppColors.lightBackground,
                              color: pct >= 85
                                  ? Colors.green.shade600
                                  : (pct >= 75 ? Colors.orange.shade600 : Colors.redAccent),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Present: ${item['present']} classes',
                                  style: const TextStyle(fontSize: 11, color: Colors.green)),
                              Text('Absent: ${item['absent']} classes',
                                  style: const TextStyle(fontSize: 11, color: Colors.redAccent)),
                              Text('Total: $total',
                                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusBadge(double percentage) {
    String label;
    Color color;
    Color bgColor;

    if (percentage >= 85) {
      label = 'Good Attendance';
      color = Colors.green.shade800;
      bgColor = Colors.green.shade50;
    } else if (percentage >= 75) {
      label = 'Attendance Needs Attention';
      color = Colors.orange.shade800;
      bgColor = Colors.orange.shade50;
    } else {
      label = 'Low Attendance Warning';
      color = Colors.red.shade800;
      bgColor = Colors.red.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
