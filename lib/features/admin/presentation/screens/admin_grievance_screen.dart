import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminGrievanceScreen extends StatefulWidget {
  const AdminGrievanceScreen({super.key});

  @override
  State<AdminGrievanceScreen> createState() => _AdminGrievanceScreenState();
}

class _AdminGrievanceScreenState extends State<AdminGrievanceScreen> {
  final List<Map<String, String>> _tickets = [
    {
      'id': 'GR-2026-081',
      'student': 'Arun Kumar (SEC2024001)',
      'category': 'Academic & Lab',
      'subject': 'Compiler Design Lab PC performance & Software licensing issue',
      'date': '14 Aug 2026',
      'priority': 'HIGH',
      'status': 'In Progress'
    },
    {
      'id': 'GR-2026-079',
      'student': 'Priya Dharshini (SEC2024002)',
      'category': 'Hostel & Mess',
      'subject': 'Hot water availability in Block B Hostel during early morning hours',
      'date': '12 Aug 2026',
      'priority': 'MEDIUM',
      'status': 'Resolved'
    },
    {
      'id': 'GR-2026-075',
      'student': 'Karthik Raja (SEC2024003)',
      'category': 'Transport',
      'subject': 'Bus Route No. 12 timing delay near Erode Junction stop',
      'date': '10 Aug 2026',
      'priority': 'MEDIUM',
      'status': 'Resolved'
    },
    {
      'id': 'GR-2026-071',
      'student': 'Divya Bharathi (SEC2024004)',
      'category': 'Library Services',
      'subject': 'Request for additional IEEE Digital Library access terminals',
      'date': '08 Aug 2026',
      'priority': 'LOW',
      'status': 'Under Review'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                      child: const Icon(Icons.report_problem_rounded, color: AppColors.gold, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Grievance Redressal',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Transparent Feedback & Action Resolution System',
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

              // Overview Status Row
              Row(
                children: [
                  Expanded(child: _buildMetricTile('Total Complaints', '18', Icons.inbox_rounded, AppColors.primaryPurple)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildMetricTile('In Progress', '3', Icons.pending_actions_rounded, Colors.orange)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildMetricTile('Resolved', '15', Icons.check_circle_rounded, Colors.green)),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Recent Student Tickets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  final isHigh = ticket['priority'] == 'HIGH';
                  final isResolved = ticket['status'] == 'Resolved';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket['id']!,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isResolved
                                      ? Colors.green.withValues(alpha: 0.12)
                                      : (isHigh ? Colors.red.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket['status']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isResolved ? Colors.green : (isHigh ? Colors.red : Colors.orange),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(ticket['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 6),
                          Text('Category: ${ticket['category']} • Submitted by: ${ticket['student']}', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date: ${ticket['date']}', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Viewing ticket ${ticket['id']} details')),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Action & Reply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                              ),
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

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}
