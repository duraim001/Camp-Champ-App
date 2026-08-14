import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/attendance_record.dart';
import '../../../../services/mock_attendance_service.dart';
import '../../../../services/mock_sms_service.dart';
import '../widgets/attendance_student_card.dart';
import '../widgets/sms_parent_dialog.dart';
import 'attendance_history_screen.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final String _selectedClass = '3rd Year - CSE - A';
  final String _selectedSubject = 'Data Structures';
  final String _selectedDate = '12 August 2026';

  List<AttendanceRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() async {
    final list = await MockAttendanceService().getAttendanceForClass(
      teacherId: 'SEC-TCH-001',
      subjectId: 'CS301',
      classId: '3RD-CSE-A',
      date: _selectedDate,
    );
    if (mounted) {
      setState(() {
        _records = list;
        _isLoading = false;
      });
    }
  }

  void _toggleMarkAllPresent(bool? markAll) {
    if (markAll == null) return;
    setState(() {
      _records = _records.map((record) {
        return record.copyWith(
          status: markAll ? AttendanceStatus.present : AttendanceStatus.absent,
          smsSent: markAll ? false : record.smsSent,
        );
      }).toList();
    });
  }

  void _updateStatus(String studentId, AttendanceStatus newStatus) async {
    final updated = await MockAttendanceService().updateAttendanceStatus(
      studentId: studentId,
      status: newStatus,
    );

    setState(() {
      final index = _records.indexWhere((r) => r.studentId == studentId);
      if (index != -1) {
        _records[index] = updated;
      }
    });
  }

  void _notifyBulkAbsentParents() async {
    final absentRecords = _records.where((r) => r.status == AttendanceStatus.absent).toList();
    if (absentRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No absent students marked for notification.'),
          backgroundColor: AppColors.primaryPurple,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.sms_rounded, color: AppColors.gold),
            const SizedBox(width: 8),
            Text('Notify ${absentRecords.length} Parents?'),
          ],
        ),
        content: Text(
          'Send automated absence SMS to guardians of ${absentRecords.map((r) => r.studentName).join(', ')}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
            ),
            child: const Text('SEND BULK SMS', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final absentList = absentRecords.map((r) => {
        'studentId': r.studentId,
        'studentName': r.studentName,
        'parentId': 'PAR-${r.studentId}',
        'parentName': 'Parent of ${r.studentName}',
        'parentPhone': '+91 90000 00003',
      }).toList();

      await MockSmsService().sendBulkAbsenceSms(
        absentStudents: absentList,
        teacherId: 'SEC-TCH-001',
        subject: _selectedSubject,
        date: _selectedDate,
      );

      _loadAttendance();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bulk SMS Sent to ${absentRecords.length} Parents!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int presentCount = _records.where((r) => r.status == AttendanceStatus.present).length;
    final int absentCount = _records.where((r) => r.status == AttendanceStatus.absent).length;
    final bool allPresent = _records.isNotEmpty && _records.every((r) => r.status == AttendanceStatus.present);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Attendance Marking'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.gold),
            tooltip: 'Attendance History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Class & Subject Selectors Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.class_rounded, color: AppColors.primaryPurple, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$_selectedSubject • $_selectedClass',
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: $_selectedDate',
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'P: $presentCount  |  A: $absentCount',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // MARK ALL PRESENT CHECKBOX CONTROL
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: allPresent,
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) => _toggleMarkAllPresent(val),
                    ),
                    const Text(
                      'Mark All Present',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const Spacer(),
                    if (allPresent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'All Present',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Bulk Action Button for Absentees
              if (absentCount > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: _notifyBulkAbsentParents,
                    icon: const Icon(Icons.mark_chat_unread_rounded, size: 18, color: AppColors.white),
                    label: Text(
                      'NOTIFY ALL $absentCount ABSENT PARENTS',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

              // Student Attendance List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _records.length,
                        itemBuilder: (context, index) {
                          final record = _records[index];
                          return AttendanceStudentCard(
                            record: record,
                            onStatusChanged: (newStatus) => _updateStatus(record.studentId, newStatus),
                            onSmsParentTap: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => SmsParentDialog(
                                  studentId: record.studentId,
                                  studentName: record.studentName,
                                  registerNumber: record.registerNumber,
                                  subject: _selectedSubject,
                                  date: _selectedDate,
                                ),
                              );
                              if (result == true) {
                                _loadAttendance();
                              }
                            },
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
