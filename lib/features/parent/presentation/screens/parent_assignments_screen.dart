import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParentAssignmentsScreen extends StatelessWidget {
  const ParentAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> assignments = [
      {
        'title': 'Data Structures Assignment 03',
        'subject': 'Data Structures',
        'faculty': 'Dr. Ravi Kumar',
        'assigned': '10 August 2026',
        'due': '17 August 2026',
        'status': 'Pending',
      },
      {
        'title': 'DBMS ER-Diagram & SQL Practice',
        'subject': 'Database Management Systems',
        'faculty': 'Dr. Ravi Kumar',
        'assigned': '05 August 2026',
        'due': '12 August 2026',
        'status': 'Submitted',
      },
      {
        'title': 'Operating Systems Process Scheduling Lab',
        'subject': 'Operating Systems',
        'faculty': 'Prof. Suresh',
        'assigned': '01 August 2026',
        'due': '08 August 2026',
        'status': 'Submitted',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("Child's Assignments"),
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
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final item = assignments[index];
            final isPending = item['status'] == 'Pending';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                ),
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
                      Expanded(
                        child: Text(
                          item['title'] as String,
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
                          color: isPending ? Colors.orange.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isPending ? Colors.orange.shade900 : Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Subject: ${item['subject']}  •  Faculty: ${item['faculty']}',
                    style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assigned: ${item['assigned']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                      Text(
                        'Due: ${item['due']}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText),
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
