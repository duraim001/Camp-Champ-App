import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_student_service.dart';

class StudentGrievanceScreen extends StatefulWidget {
  const StudentGrievanceScreen({super.key});

  @override
  State<StudentGrievanceScreen> createState() => _StudentGrievanceScreenState();
}

class _StudentGrievanceScreenState extends State<StudentGrievanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _myGrievances = [
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

  void _showSubmitGrievanceDialog(BuildContext context) {
    final descController = TextEditingController();
    String category = 'Academic Resource';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.report_problem_rounded, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text(
                'Submit Grievance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Academic Resource', child: Text('Academic Resource')),
                    DropdownMenuItem(value: 'Attendance Verification', child: Text('Attendance Verification')),
                    DropdownMenuItem(value: 'Evaluation Query', child: Text('Evaluation Query')),
                    DropdownMenuItem(value: 'Library / Portal Access', child: Text('Library / Portal Access')),
                  ],
                  onChanged: (val) {
                    if (val != null) category = val;
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe your query or grievance in detail...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton(
              onPressed: () {
                if (descController.text.trim().isNotEmpty) {
                  setState(() {
                    _myGrievances.insert(0, {
                      'id': 'GRV-2026-09${_myGrievances.length + 1}',
                      'category': category,
                      'subject': 'General Academic',
                      'description': descController.text.trim(),
                      'date': '16 Aug 2026',
                      'status': 'OPEN',
                      'response': 'Submitted to Department Advisor.',
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Grievance submitted successfully! Tracking ID generated.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('SUBMIT', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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
              Tab(text: 'My Grievances'),
              Tab(text: 'Performance Prediction'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMyGrievancesTab(),
              _buildPerformancePredictionTab(),
            ],
          ),
        ),
      ],
    );
  }

  // TAB 1: MY GRIEVANCES
  Widget _buildMyGrievancesTab() {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubmitGrievanceDialog(context),
        backgroundColor: AppColors.gold,
        icon: const Icon(Icons.add_rounded, color: AppColors.primaryPurple),
        label: const Text(
          'NEW GRIEVANCE',
          style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _myGrievances.length,
        itemBuilder: (context, index) {
          final item = _myGrievances[index];
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
    );
  }

  // TAB 2: AI PERFORMANCE PREDICTION FOR LOGGED-IN STUDENT
  Widget _buildPerformancePredictionTab() {
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
                        'AI Academic Performance Indicator',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Personalized academic trend analysis based on current attendance, CIA 1/2/3, & assignment records. Not a guaranteed result.',
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
                          student.name,
                          style: const TextStyle(
                            fontSize: 18,
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
                        'Reasoning / Analysis:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your attendance is consistent at 87% (above the 75% threshold) and your CIA test scores show a positive upward trend (CIA 1: 78% ➔ CIA 3: 86%).',
                        style: TextStyle(fontSize: 12, color: AppColors.darkText, height: 1.3),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Recommendation: Maintain regular revision in Database Systems to aim for distinction.',
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

          _buildTrendRow('Overall Attendance', '87%', 'Above 75% Cutoff', Colors.green),
          _buildTrendRow('CIA 1 Average', '78%', 'Satisfactory Start', Colors.amber.shade800),
          _buildTrendRow('CIA 2 Average', '82%', 'Positive Growth (+4%)', Colors.green),
          _buildTrendRow('CIA 3 Average', '86%', 'Strong Distinction (+4%)', Colors.green),
          _buildTrendRow('Assignments Submission', '4 / 4 Complete', '100% Submission Rate', Colors.green),
          _buildTrendRow('Semester Performance Trend', 'Upward ↗', 'Consistent Improvement', Colors.green),
        ],
      ),
    );
  }

  Widget _buildTrendRow(String title, String val, String subtitle, Color color) {
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
