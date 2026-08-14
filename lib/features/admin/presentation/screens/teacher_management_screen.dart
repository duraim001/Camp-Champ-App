import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/teacher.dart';
import '../../../../services/mock_teacher_service.dart';
import '../widgets/user_status_badge.dart';

class TeacherManagementScreen extends StatefulWidget {
  const TeacherManagementScreen({super.key});

  @override
  State<TeacherManagementScreen> createState() =>
      _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen> {
  final _searchController = TextEditingController();
  String _selectedDept = 'All';
  List<TeacherModel> _displayedTeachers = [];

  final List<String> _departments = [
    'All',
    'Computer Science',
    'Information Technology',
    'Mechanical Engineering',
    'Electronics & Comm.',
    'Electrical & Elec.',
  ];

  @override
  void initState() {
    super.initState();
    _filterTeachers();
  }

  void _filterTeachers() {
    setState(() {
      _displayedTeachers = MockTeacherService().searchTeachers(
        _searchController.text,
        department: _selectedDept,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Teacher Management'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Teacher ready for Step 4')),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: AppColors.gold),
        label: const Text('Add Teacher',
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
                onChanged: (_) => _filterTeachers(),
                decoration: InputDecoration(
                  hintText: 'Search by faculty name or ID...',
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
                              _filterTeachers();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Teacher List
              Expanded(
                child: _displayedTeachers.isEmpty
                    ? const Center(
                        child: Text('No matching teachers found.'),
                      )
                    : ListView.builder(
                        itemCount: _displayedTeachers.length,
                        itemBuilder: (context, index) {
                          final teacher = _displayedTeachers[index];
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
                                        teacher.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                      UserStatusBadge(
                                        status: teacher.isPresent
                                            ? 'Present'
                                            : 'Absent',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Faculty ID: ${teacher.facultyId}  •  Dept: ${teacher.department}',
                                    style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    'Subject: ${teacher.subject}',
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
                                        'Overall Attendance: ${teacher.attendancePercentage}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors.primaryPurple,
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
                                                Icons.person_off_outlined,
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
