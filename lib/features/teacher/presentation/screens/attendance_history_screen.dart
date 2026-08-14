import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/attendance_record.dart';
import '../../../../services/mock_attendance_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List<AttendanceRecord> _history = [];
  bool _isLoading = true;
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final list = await MockAttendanceService().getAttendanceHistory();
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _history.where((r) {
      if (_selectedFilter == 'PRESENT') return r.status == AttendanceStatus.present;
      if (_selectedFilter == 'ABSENT') return r.status == AttendanceStatus.absent;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filter options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['ALL', 'PRESENT', 'ABSENT'].map((filter) {
                  final bool isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryPurple : AppColors.darkText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                    : filteredList.isEmpty
                        ? const Center(
                            child: Text(
                              'No attendance history records found',
                              style: TextStyle(color: AppColors.secondaryText),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final r = filteredList[index];
                              final bool isAbsent = r.status == AttendanceStatus.absent;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.primaryPurple.withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isAbsent
                                          ? Colors.red.withValues(alpha: 0.1)
                                          : Colors.green.withValues(alpha: 0.1),
                                      child: Icon(
                                        isAbsent ? Icons.close_rounded : Icons.check_rounded,
                                        color: isAbsent ? Colors.red : Colors.green,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r.studentName,
                                            style: const TextStyle(
                                              color: AppColors.darkText,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${r.registerNumber}  •  ${r.date}',
                                            style: const TextStyle(
                                              color: AppColors.secondaryText,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            'Subject: ${r.subjectName}',
                                            style: const TextStyle(
                                              color: AppColors.secondaryText,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isAbsent
                                                ? Colors.red.withValues(alpha: 0.12)
                                                : Colors.green.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            r.status.label,
                                            style: TextStyle(
                                              color: isAbsent ? Colors.red : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        if (isAbsent) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            r.smsSent ? 'Parent SMS: SENT' : 'Parent SMS: Pending',
                                            style: TextStyle(
                                              color: r.smsSent ? Colors.green : AppColors.secondaryText,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
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
