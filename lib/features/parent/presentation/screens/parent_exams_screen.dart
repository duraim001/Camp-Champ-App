import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParentExamsScreen extends StatelessWidget {
  const ParentExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> timetable = [
      {
        'subject': 'Database Management Systems',
        'code': 'CS8591',
        'date': '20 Sep 2026',
        'time': '10:00 AM - 01:00 PM',
        'hall': 'A Block - Hall 204',
        'type': 'Semester Theory',
      },
      {
        'subject': 'Data Structures & Algorithms',
        'code': 'CS8391',
        'date': '22 Sep 2026',
        'time': '10:00 AM - 01:00 PM',
        'hall': 'A Block - Hall 204',
        'type': 'Semester Theory',
      },
      {
        'subject': 'Computer Networks',
        'code': 'CS8592',
        'date': '24 Sep 2026',
        'time': '10:00 AM - 01:00 PM',
        'hall': 'B Block - Hall 102',
        'type': 'Semester Theory',
      },
      {
        'subject': 'Operating Systems',
        'code': 'CS8493',
        'date': '26 Sep 2026',
        'time': '10:00 AM - 01:00 PM',
        'hall': 'A Block - Hall 204',
        'type': 'Semester Theory',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A. COMPLETED EXAM CARD
            const Text(
              'RECENTLY COMPLETED EXAM',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CIA 3 Internal Assessment',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Text(
                            'COMPLETED',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Subject: Data Structures (CS8391)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Exam Date: 10 August 2026 • Marks Secured: 86 / 100 (Grade: A)',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // B. NEXT EXAM CARD
            const Text(
              'NEXT UPCOMING EXAM',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.25),
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
                      const Text(
                        'SEMESTER EXAM 5',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: const Text(
                          'UPCOMING',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Database Management Systems',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Date: 20 September 2026  •  Time: 10:00 AM',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Hall Location: A Block — Room 204',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // C. UPCOMING EXAM TIMETABLE
            const Text(
              'FULL EXAMINATION TIMETABLE',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timetable.length,
              itemBuilder: (context, index) {
                final item = timetable[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.event_available_rounded, color: AppColors.primaryPurple, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['subject']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                              ),
                              Text(
                                '${item['code']} • ${item['type']}',
                                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['date']} (${item['time']}) • ${item['hall']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
