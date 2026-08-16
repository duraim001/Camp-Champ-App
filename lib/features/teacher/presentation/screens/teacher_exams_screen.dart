import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TeacherExamsScreen extends StatefulWidget {
  const TeacherExamsScreen({super.key});

  @override
  State<TeacherExamsScreen> createState() => _TeacherExamsScreenState();
}

class _TeacherExamsScreenState extends State<TeacherExamsScreen> {
  String _selectedYear = '3rd Year';
  String _selectedSubject = 'Data Structures';

  final List<String> _years = ['2nd Year', '3rd Year', '4th Year'];
  final List<String> _mySubjects = [
    'Data Structures',
    'Database Management Systems',
    'Computer Networks',
    'Operating Systems',
  ];

  // Demo student exam marks data
  final List<Map<String, dynamic>> _studentExamMarks = [
    {
      'name': 'Arun Kumar',
      'regNo': 'SEC2024CS001',
      'year': '3rd Year',
      'dept': 'Computer Science',
      'subject': 'Data Structures',
      'cia1': 82,
      'cia2': 76,
      'cia3': 88,
      'semester': 81,
      'status': 'PASSED',
      'overall': 'Good',
    },
    {
      'name': 'Deepak S',
      'regNo': 'SEC2024CS002',
      'year': '3rd Year',
      'dept': 'Computer Science',
      'subject': 'Data Structures',
      'cia1': 91,
      'cia2': 89,
      'cia3': 94,
      'semester': 90,
      'status': 'PASSED',
      'overall': 'Excellent',
    },
    {
      'name': 'Kavya M',
      'regNo': 'SEC2024CS003',
      'year': '3rd Year',
      'dept': 'Computer Science',
      'subject': 'Data Structures',
      'cia1': 65,
      'cia2': 58,
      'cia3': 70,
      'semester': 64,
      'status': 'PASSED',
      'overall': 'Needs Improvement',
    },
    {
      'name': 'Priya R',
      'regNo': 'SEC2024CS004',
      'year': '3rd Year',
      'dept': 'Computer Science',
      'subject': 'Database Management Systems',
      'cia1': 88,
      'cia2': 85,
      'cia3': 92,
      'semester': 88,
      'status': 'PASSED',
      'overall': 'Good',
    },
    {
      'name': 'Suresh V',
      'regNo': 'SEC2024CS005',
      'year': '3rd Year',
      'dept': 'Computer Science',
      'subject': 'Computer Networks',
      'cia1': 45,
      'cia2': 52,
      'cia3': 48,
      'semester': 49,
      'status': 'AT RISK',
      'overall': 'At Risk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _studentExamMarks.where((s) {
      return s['year'] == _selectedYear && s['subject'] == _selectedSubject;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MY ASSIGNED SUBJECTS HEADER CARD
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
                  color: AppColors.primaryPurple.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment_turned_in_rounded,
                        color: AppColors.gold, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'MY SUBJECTS & EXAMINATIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _mySubjects.map((subject) {
                    final isSelected = subject == _selectedSubject;
                    return ChoiceChip(
                      label: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primaryPurple
                              : AppColors.white,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      backgroundColor:
                          AppColors.white.withValues(alpha: 0.15),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.white.withValues(alpha: 0.3),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedSubject = subject;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ACADEMIC YEAR SELECTOR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Class / Year:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              Row(
                children: _years.map((year) {
                  final isSelected = year == _selectedYear;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedYear = year;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryPurple
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryPurple
                                : AppColors.primaryPurple.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          year,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // MARKS OVERVIEW FOR SELECTED CLASS & SUBJECT
          Text(
            '$_selectedYear • $_selectedSubject (${filteredStudents.length} Students)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 10),

          if (filteredStudents.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.school_outlined,
                      size: 40, color: AppColors.secondaryText),
                  SizedBox(height: 8),
                  Text(
                    'No student marks records found for this year.',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final s = filteredStudents[index];
                return _buildStudentExamCard(context, s);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStudentExamCard(
      BuildContext context, Map<String, dynamic> student) {
    final bool isPassed = student['status'] == 'PASSED';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.12),
        ),
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
          // Header: Name, Reg No & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Reg No: ${student['regNo']} • ${student['dept']}',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPassed
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPassed
                        ? Colors.green.withValues(alpha: 0.4)
                        : Colors.orange.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  student['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? Colors.green : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Marks Grid: CIA 1, CIA 2, CIA 3, Semester
          Row(
            children: [
              _buildMarkTile('CIA 1', '${student['cia1']}%', AppColors.primaryPurple),
              _buildMarkTile('CIA 2', '${student['cia2']}%', AppColors.secondaryPurple),
              _buildMarkTile('CIA 3', '${student['cia3']}%', AppColors.primaryPurple),
              _buildMarkTile('Semester', '${student['semester']}%', AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkTile(String title, String mark, Color accentColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accentColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mark,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
