import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/student.dart';
import '../../../../services/mock_student_service.dart';
import '../widgets/user_status_badge.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final _searchController = TextEditingController();
  String _selectedDept = 'All';
  List<StudentModel> _displayedStudents = [];

  final List<String> _departments = [
    'All',
    'Artificial Intelligence & Data Science',
    'Computer Science',
    'Information Technology',
    'Mechanical Engineering',
    'Electronics & Comm.',
    'Electrical & Elec.',
    'Civil Engineering',
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    final list = await MockStudentService().getAllStudentsAsync();
    if (mounted) {
      setState(() {
        _displayedStudents = list;
        _isLoading = false;
      });
    }
  }

  void _filterStudents() async {
    final query = _searchController.text.trim();
    final deptFilter = _selectedDept == 'All'
        ? null
        : (_selectedDept.contains('Artificial Intelligence') ? 'AI&DS' : _selectedDept);

    final list = await MockStudentService().getAllStudentsAsync(
      department: deptFilter,
    );

    if (mounted) {
      setState(() {
        if (query.isNotEmpty) {
          final q = query.toLowerCase();
          _displayedStudents = list.where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.registerNumber.toLowerCase().contains(q) ||
              s.rollNumber.toLowerCase().contains(q)).toList();
        } else {
          _displayedStudents = list;
        }
      });
    }
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student',
            style: TextStyle(color: AppColors.primaryPurple)),
        content: const Text(
            'Add Student functionality is ready for database connection.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStudentDialog,
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: AppColors.gold),
        label: const Text('Add Student',
            style: TextStyle(
                color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                onChanged: (_) => _filterStudents(),
                decoration: InputDecoration(
                  hintText: 'Search by name or register number...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.primaryPurple),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Filter Row
              Row(
                children: [
                  const Text('Department: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                AppColors.primaryPurple.withValues(alpha: 0.2)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDept,
                          isExpanded: true,
                          items: _departments.map((dept) {
                            return DropdownMenuItem(
                              value: dept,
                              child: Text(dept,
                                  style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              _selectedDept = val;
                              _filterStudents();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Student List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryPurple,
                        ),
                      )
                    : _displayedStudents.isEmpty
                        ? const Center(
                            child: Text('No matching students found.'),
                          )
                        : ListView.builder(
                        itemCount: _displayedStudents.length,
                        itemBuilder: (context, index) {
                          final student = _displayedStudents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: AppColors.primaryPurple
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        student.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                      UserStatusBadge(status: student.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Reg No: ${student.registerNumber}  •  ${student.year} (${student.section})',
                                    style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    'Dept: ${student.department}',
                                    style: const TextStyle(
                                        color: AppColors.darkText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Attendance: ${student.attendancePercentage}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: student.attendancePercentage >=
                                                  75
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 18,
                                                color: AppColors.primaryPurple),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.block_outlined,
                                                size: 18,
                                                color: Colors.redAccent),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
