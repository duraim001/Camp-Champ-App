import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TeacherGrievanceScreen extends StatefulWidget {
  const TeacherGrievanceScreen({super.key});

  @override
  State<TeacherGrievanceScreen> createState() => _TeacherGrievanceScreenState();
}

class _TeacherGrievanceScreenState extends State<TeacherGrievanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedYear = '3rd Year';

  final List<String> _years = ['2nd Year', '3rd Year', '4th Year'];

  // Demo Grievance Tickets
  final List<Map<String, dynamic>> _grievances = [
    {
      'id': 'GRV-2026-081',
      'studentName': 'Arun Kumar',
      'class': '3rd Year CSE - A',
      'category': 'Academic Resource',
      'description': 'Request for additional practice questions for Data Structures Lab exam.',
      'date': '14 Aug 2026',
      'status': 'OPEN',
      'resolution': 'Pending faculty review',
    },
    {
      'id': 'GRV-2026-074',
      'studentName': 'Kavya M',
      'class': '3rd Year CSE - A',
      'category': 'Attendance Correction',
      'description': 'On-Duty certificate submitted for Sports Meet on 10 Aug 2026.',
      'date': '12 Aug 2026',
      'status': 'IN PROGRESS',
      'resolution': 'OD Certificate under verification',
    },
    {
      'id': 'GRV-2026-062',
      'studentName': 'Suresh V',
      'class': '3rd Year CSE - B',
      'category': 'CIA Revaluation',
      'description': 'Requested revaluation for DBMS CIA-2 Question 4 evaluation.',
      'date': '08 Aug 2026',
      'status': 'RESOLVED',
      'resolution': 'Marks updated after paper recheck',
    },
  ];

  // Demo Performance Prediction Data
  final List<Map<String, dynamic>> _predictions = [
    {
      'name': 'Arun Kumar',
      'regNo': 'SEC2024CS001',
      'year': '3rd Year',
      'attendance': '92%',
      'cia1': '82%',
      'cia2': '76%',
      'cia3': '88%',
      'assignments': '4 / 5 Submitted',
      'semesterScore': '81%',
      'trend': 'Stable High',
      'status': 'Good', // Good, Needs Improvement, At Risk
      'badgeColor': Colors.green,
      'reason': 'Strong CIA performance and consistent attendance above 90%.',
      'recommendation': 'Maintain current momentum for end-semester exams.',
    },
    {
      'name': 'Kavya M',
      'regNo': 'SEC2024CS003',
      'year': '3rd Year',
      'attendance': '78%',
      'cia1': '65%',
      'cia2': '58%',
      'cia3': '70%',
      'assignments': '3 / 5 Submitted',
      'semesterScore': '64%',
      'trend': 'Fluctuating',
      'status': 'Needs Improvement',
      'badgeColor': Colors.amber,
      'reason': 'Attendance is near the cutoff threshold and CIA 2 marks dropped.',
      'recommendation': 'Provide additional remedial tutoring for core modules.',
    },
    {
      'name': 'Suresh V',
      'regNo': 'SEC2024CS005',
      'year': '3rd Year',
      'attendance': '68%',
      'cia1': '45%',
      'cia2': '52%',
      'cia3': '48%',
      'assignments': '2 / 5 Submitted',
      'semesterScore': '49%',
      'trend': 'Declining',
      'status': 'At Risk',
      'badgeColor': Colors.red,
      'reason': 'Attendance below 75% requirement and consistently low CIA scores.',
      'recommendation': 'Schedule immediate parent-teacher consultation.',
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
        // TAB HEADER
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
              Tab(text: 'Student Grievances'),
              Tab(text: 'Performance Prediction'),
            ],
          ),
        ),

        // TAB VIEW BODY
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGrievancesList(),
              _buildPerformancePredictionSection(),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 1: STUDENT GRIEVANCE LIST ---
  Widget _buildGrievancesList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _grievances.length,
      itemBuilder: (context, index) {
        final item = _grievances[index];
        final bool isResolved = item['status'] == 'RESOLVED';
        final bool isInProgress = item['status'] == 'IN PROGRESS';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.primaryPurple.withValues(alpha: 0.12),
            ),
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
                            : (isInProgress
                                ? Colors.amber.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.12)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isResolved
                              ? Colors.green
                              : (isInProgress ? Colors.amber.shade900 : Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['studentName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  '${item['class']} • ${item['category']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'],
                  style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${item['date']}',
                      style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    ),
                    Text(
                      item['resolution'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TAB 2: AI STUDENT PERFORMANCE PREDICTION ---
  Widget _buildPerformancePredictionSection() {
    final filteredPredictions = _predictions.where((p) => p['year'] == _selectedYear).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ACADEMIC PREDICTION DISCLAIMER BANNER
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
                        'AI Academic Performance Prediction',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Academic indicator based on attendance, CIA 1/2/3, & assignment trends. Not a final guaranteed result.',
                        style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // YEAR FILTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Academic Year:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              Row(
                children: _years.map((year) {
                  final isSelected = year == _selectedYear;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Text(
                        year,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      backgroundColor: AppColors.white,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedYear = year;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // PREDICTION CARDS LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredPredictions.length,
            itemBuilder: (context, index) {
              final p = filteredPredictions[index];
              return _buildPredictionCard(context, p);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(BuildContext context, Map<String, dynamic> p) {
    final Color statusColor = p['badgeColor'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student & Indicator Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      'Reg No: ${p['regNo']} • ${p['year']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      p['status'] == 'Good'
                          ? Icons.check_circle_rounded
                          : (p['status'] == 'Needs Improvement'
                              ? Icons.warning_amber_rounded
                              : Icons.error_rounded),
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Prediction: ${p['status']}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metrics Summary Row
          Row(
            children: [
              _buildMiniMetric('Attendance', p['attendance']),
              _buildMiniMetric('CIA 1', p['cia1']),
              _buildMiniMetric('CIA 2', p['cia2']),
              _buildMiniMetric('CIA 3', p['cia3']),
            ],
          ),
          const SizedBox(height: 12),

          // Reason & Recommendation
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason: ${p['reason']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recommendation: ${p['recommendation']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String val) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
