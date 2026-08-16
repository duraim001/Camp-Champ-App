import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_student_service.dart';

class ParentGrievanceScreen extends StatefulWidget {
  const ParentGrievanceScreen({super.key});

  @override
  State<ParentGrievanceScreen> createState() => _ParentGrievanceScreenState();
}

class _ParentGrievanceScreenState extends State<ParentGrievanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _childGrievances = [
    {
      'id': 'GRV-2026-081',
      'category': 'Academic Resource',
      'subject': 'Data Structures',
      'description': 'Request for additional practice questions for Data Structures Lab exam.',
      'date': '14 Aug 2026',
      'status': 'OPEN',
      'response': 'Faculty assigned. Pending review.',
    },
    {
      'id': 'GRV-2026-042',
      'category': 'Attendance Verification',
      'subject': 'Database Systems',
      'description': 'On-Duty certificate submitted for Inter-College Hackathon on 02 Aug 2026.',
      'date': '04 Aug 2026',
      'status': 'RESOLVED',
      'response': 'OD attendance updated in register.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primaryPurple,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.gold,
            indicatorWeight: 3,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.white.withValues(alpha: 0.7),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: "Child's Grievances"),
              Tab(text: 'Performance Prediction'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGrievanceTab(),
              _buildPredictionTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrievanceTab() {
    final student = MockStudentService().getDemoStudentProfile();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primaryPurple, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Showing grievances & requests for ${student.name} (Reg: ${student.registerNumber}).',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _childGrievances.length,
              itemBuilder: (context, index) {
                final item = _childGrievances[index];
                final bool isResolved = item['status'] == 'RESOLVED';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['id'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: isResolved
                                    ? Colors.green.withValues(alpha: 0.12)
                                    : Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: isResolved ? Colors.green : Colors.orange.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['category'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'],
                          style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Submitted: ${item['date']}',
                                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                            Expanded(
                              child: Text(
                                'Response: ${item['response']}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
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
    );
  }

  Widget _buildPredictionTab() {
    final student = MockStudentService().getDemoStudentProfile();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DISCLAIMER BANNER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.15)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Child Academic Performance Indicator',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Academic trend indicator based on attendance, CIA 1/2/3, & assignment records. Not a guaranteed result.',
                        style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // OVERALL PREDICTION CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.05),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student: ${student.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Text(
                          'Reg No: ${student.registerNumber} • ${student.department}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Prediction: 🟢 GOOD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reasoning / Academic Analysis:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Arun\'s attendance is consistent at 87% (above 75% requirement) and CIA test scores show a positive upward trend (CIA 1: 78% ➔ CIA 3: 86%).',
                        style: TextStyle(fontSize: 12, color: AppColors.darkText, height: 1.3),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Parent Guidance: Encourage regular revision in Database Systems for upcoming semester exams.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // DETAILED ACADEMIC TREND BREAKDOWN
          const Text(
            'PERFORMANCE METRICS BREAKDOWN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPurple,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),

          _buildMetricRow('Overall Attendance', '87%', 'Above 75% Cutoff', Colors.green),
          _buildMetricRow('CIA 1 Score', '78%', 'Satisfactory Start', Colors.amber.shade800),
          _buildMetricRow('CIA 2 Score', '82%', 'Positive Growth (+4%)', Colors.green),
          _buildMetricRow('CIA 3 Score', '86%', 'Strong Distinction (+4%)', Colors.green),
          _buildMetricRow('Assignment Record', '4 / 4 Submitted', '100% Submission Rate', Colors.green),
          _buildMetricRow('Semester Progress Trend', 'Upward ↗', 'Consistent Improvement', Colors.green),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String title, String val, String subtitle, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
            Text(
              val,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
