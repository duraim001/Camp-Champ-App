import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParentAcademicPerformanceScreen extends StatefulWidget {
  const ParentAcademicPerformanceScreen({super.key});

  @override
  State<ParentAcademicPerformanceScreen> createState() => _ParentAcademicPerformanceScreenState();
}

class _ParentAcademicPerformanceScreenState extends State<ParentAcademicPerformanceScreen> {
  String _selectedFilter = 'VIEW ALL';

  final List<Map<String, dynamic>> _subjectMarks = [
    {
      'subject': 'Data Structures',
      'code': 'CS601',
      'cia1': 82,
      'cia2': 86,
      'cia3': 88,
      'max': 100,
    },
    {
      'subject': 'Database Management Systems',
      'code': 'CS602',
      'cia1': 78,
      'cia2': 84,
      'cia3': 81,
      'max': 100,
    },
    {
      'subject': 'Operating Systems',
      'code': 'CS603',
      'cia1': 75,
      'cia2': 80,
      'cia3': 85,
      'max': 100,
    },
    {
      'subject': 'Computer Networks',
      'code': 'CS604',
      'cia1': 88,
      'cia2': 90,
      'cia3': 87,
      'max': 100,
    },
    {
      'subject': 'Software Engineering',
      'code': 'CS605',
      'cia1': 84,
      'cia2': 86,
      'cia3': 90,
      'max': 100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Academic Performance (CIA)'),
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
              // Filter Chips (CIA 1, CIA 2, CIA 3, VIEW ALL)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['VIEW ALL', 'CIA 1', 'CIA 2', 'CIA 3'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.white : AppColors.primaryPurple,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryPurple,
                    backgroundColor: AppColors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryPurple : AppColors.primaryPurple.withValues(alpha: 0.2),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = filter);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Subject Cards
              ..._subjectMarks.map((data) => _buildSubjectMarkCard(data)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectMarkCard(Map<String, dynamic> data) {
    final cia1 = data['cia1'] as int;
    final cia2 = data['cia2'] as int;
    final cia3 = data['cia3'] as int;
    final avg = ((cia1 + cia2 + cia3) / 3.0).roundToDouble();

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['subject'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  Text(
                    'Code: ${data['code']}',
                    style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Avg: $avg%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Scores Row
          if (_selectedFilter == 'VIEW ALL' || _selectedFilter == 'CIA 1')
            _buildScoreRow('CIA 1', cia1, data['max'] as int),
          if (_selectedFilter == 'VIEW ALL' || _selectedFilter == 'CIA 2')
            _buildScoreRow('CIA 2', cia2, data['max'] as int),
          if (_selectedFilter == 'VIEW ALL' || _selectedFilter == 'CIA 3')
            _buildScoreRow('CIA 3', cia3, data['max'] as int),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, int mark, int maxMark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$mark ',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                TextSpan(
                  text: '/ $maxMark',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
