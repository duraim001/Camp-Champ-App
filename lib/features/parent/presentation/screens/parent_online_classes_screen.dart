import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParentOnlineClassesScreen extends StatelessWidget {
  const ParentOnlineClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> classes = [
      {
        'subject': 'Data Structures',
        'faculty': 'Dr. Ravi Kumar',
        'date': '12 August 2026',
        'time': '10:00 AM – 11:00 AM',
        'platform': 'Google Meet',
        'status': 'UPCOMING',
      },
      {
        'subject': 'Database Management Systems',
        'faculty': 'Dr. Ravi Kumar',
        'date': '13 August 2026',
        'time': '02:00 PM – 03:00 PM',
        'platform': 'Google Meet',
        'status': 'UPCOMING',
      },
      {
        'subject': 'Operating Systems',
        'faculty': 'Prof. Suresh',
        'date': '11 August 2026',
        'time': '11:15 AM – 12:15 PM',
        'platform': 'Google Meet',
        'status': 'COMPLETED',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("Child's Online Classes"),
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
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final item = classes[index];
            final isUpcoming = item['status'] == 'UPCOMING';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.04),
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
                      Text(
                        item['subject'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUpcoming ? Colors.blue.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isUpcoming ? Colors.blue.shade900 : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Faculty: ${item['faculty']}  •  Platform: ${item['platform']}',
                    style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const Divider(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.secondaryText),
                      const SizedBox(width: 6),
                      Text(
                        item['date'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkText),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.secondaryText),
                      const SizedBox(width: 6),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkText),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
