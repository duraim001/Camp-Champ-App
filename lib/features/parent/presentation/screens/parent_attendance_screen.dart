import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParentAttendanceScreen extends StatelessWidget {
  const ParentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double overallPercentage = 87.5;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Child Attendance'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'VIEW ONLY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Attendance Card Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arun Kumar (SEC2024001)',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '3rd Year — CSE — Section A',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: AppColors.gold,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('OVERALL', '87.5%', AppColors.gold),
                        _buildSummaryItem('PRESENT', '180', AppColors.white),
                        _buildSummaryItem('ABSENT', '22', Colors.redAccent.shade100),
                        _buildSummaryItem('TOTAL', '202', AppColors.white),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status Indicator Banner
              _buildAttendanceStatusBanner(overallPercentage),
              const SizedBox(height: 20),

              const Text(
                'Subject-wise Attendance',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 12),

              _buildSubjectAttendanceCard('Data Structures', present: 38, absent: 4, percentage: 90.0),
              _buildSubjectAttendanceCard('Database Management Systems', present: 35, absent: 5, percentage: 87.5),
              _buildSubjectAttendanceCard('Operating Systems', present: 34, absent: 6, percentage: 85.0),
              _buildSubjectAttendanceCard('Computer Networks', present: 37, absent: 3, percentage: 92.5),
              _buildSubjectAttendanceCard('Software Engineering', present: 36, absent: 4, percentage: 90.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStatusBanner(double percentage) {
    String statusTitle;
    String statusDesc;
    Color statusColor;
    IconData statusIcon;

    if (percentage >= 85.0) {
      statusTitle = 'Good Attendance';
      statusDesc = 'Your child has a healthy attendance record.';
      statusColor = Colors.green.shade700;
      statusIcon = Icons.check_circle_rounded;
    } else if (percentage >= 75.0) {
      statusTitle = 'Attendance Needs Attention';
      statusDesc = 'Your child’s attendance is near the 75% threshold.';
      statusColor = Colors.orange.shade800;
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusTitle = 'Low Attendance Warning';
      statusDesc = 'Your child’s attendance is below the recommended level (75%).';
      statusColor = Colors.red.shade700;
      statusIcon = Icons.error_outline_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusDesc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAttendanceCard(
    String subjectName, {
    required int present,
    required int absent,
    required double percentage,
  }) {
    final total = present + absent;
    final color = percentage >= 85.0 ? Colors.green.shade700 : (percentage >= 75.0 ? Colors.orange.shade800 : Colors.red.shade700);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subjectName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.lightBackground,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Present: $present classes',
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
              Text(
                'Absent: $absent classes',
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
              Text(
                'Total: $total classes',
                style: const TextStyle(fontSize: 12, color: AppColors.darkText, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
