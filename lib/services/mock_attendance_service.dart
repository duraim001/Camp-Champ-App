import '../models/attendance_record.dart';
import 'mock_student_service.dart';

class MockAttendanceService {
  static final MockAttendanceService _instance = MockAttendanceService._internal();
  factory MockAttendanceService() => _instance;
  MockAttendanceService._internal() {
    _initDemoRecords();
  }

  final Map<String, AttendanceRecord> _todayRecords = {};
  final List<AttendanceRecord> _historyRecords = [];

  void _initDemoRecords() {
    final students = [
      {'id': '1', 'name': 'Arun Kumar', 'reg': 'SEC2024001', 'status': AttendanceStatus.present},
      {'id': '2', 'name': 'Priya S', 'reg': 'SEC2024002', 'status': AttendanceStatus.present},
      {'id': '3', 'name': 'Karthik M', 'reg': 'SEC2024003', 'status': AttendanceStatus.absent},
      {'id': '4', 'name': 'Divya R', 'reg': 'SEC2024004', 'status': AttendanceStatus.present},
      {'id': '5', 'name': 'Vignesh P', 'reg': 'SEC2024005', 'status': AttendanceStatus.absent},
      {'id': '6', 'name': 'Anitha K', 'reg': 'SEC2024006', 'status': AttendanceStatus.present},
      {'id': '7', 'name': 'Rahul V', 'reg': 'SEC2024007', 'status': AttendanceStatus.present},
      {'id': '8', 'name': 'Sneha M', 'reg': 'SEC2024008', 'status': AttendanceStatus.present},
      {'id': '9', 'name': 'Deepak S', 'reg': 'SEC2024009', 'status': AttendanceStatus.present},
      {'id': '10', 'name': 'Kavitha N', 'reg': 'SEC2024010', 'status': AttendanceStatus.present},
    ];

    for (var s in students) {
      final studentId = s['id'] as String;
      final record = AttendanceRecord(
        id: 'ATT-20260812-$studentId',
        studentId: studentId,
        studentName: s['name'] as String,
        registerNumber: s['reg'] as String,
        teacherId: 'SEC-TCH-001',
        classId: '3RD-CSE-A',
        subjectId: 'CS301',
        subjectName: 'Data Structures',
        date: '12 August 2026',
        time: '10:00 AM - 11:00 AM',
        status: s['status'] as AttendanceStatus,
        smsSent: (s['status'] == AttendanceStatus.absent),
        smsSentAt: (s['status'] == AttendanceStatus.absent) ? '10:15 AM' : null,
      );
      _todayRecords[studentId] = record;
      _historyRecords.add(record);
    }
  }

  Future<List<AttendanceRecord>> getAttendanceForClass({
    required String teacherId,
    required String subjectId,
    required String classId,
    required String date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final students = await MockStudentService().getAssignedStudents(teacherId);

    return students.map((s) {
      if (_todayRecords.containsKey(s.id)) {
        return _todayRecords[s.id]!;
      }
      return AttendanceRecord(
        id: 'ATT-${DateTime.now().millisecondsSinceEpoch}-${s.id}',
        studentId: s.id,
        studentName: s.name,
        registerNumber: s.registerNumber,
        teacherId: teacherId,
        classId: classId,
        subjectId: subjectId,
        subjectName: 'Data Structures',
        date: date,
        time: '10:00 AM - 11:00 AM',
        status: AttendanceStatus.notMarked,
      );
    }).toList();
  }

  Future<AttendanceRecord> updateAttendanceStatus({
    required String studentId,
    required AttendanceStatus status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final existing = _todayRecords[studentId];
    if (existing == null) {
      final student = await MockStudentService().getStudentByRegisterNumber(studentId);
      final newRecord = AttendanceRecord(
        id: 'ATT-${DateTime.now().millisecondsSinceEpoch}-$studentId',
        studentId: studentId,
        studentName: student?.name ?? 'Student $studentId',
        registerNumber: student?.registerNumber ?? 'SEC2024$studentId',
        teacherId: 'SEC-TCH-001',
        classId: '3RD-CSE-A',
        subjectId: 'CS301',
        subjectName: 'Data Structures',
        date: '12 August 2026',
        time: '10:00 AM - 11:00 AM',
        status: status,
        smsSent: false,
      );
      _todayRecords[studentId] = newRecord;
      _historyRecords.insert(0, newRecord);
      return newRecord;
    } else {
      // If changing status from ABSENT to PRESENT, reset smsSent status
      final bool resetSms = (status == AttendanceStatus.present);
      final updated = existing.copyWith(
        status: status,
        smsSent: resetSms ? false : existing.smsSent,
        smsSentAt: resetSms ? null : existing.smsSentAt,
      );
      _todayRecords[studentId] = updated;
      
      final index = _historyRecords.indexWhere((r) => r.studentId == studentId && r.date == updated.date);
      if (index != -1) {
        _historyRecords[index] = updated;
      }
      return updated;
    }
  }

  Future<void> markSmsSent(String studentId) async {
    final existing = _todayRecords[studentId];
    if (existing != null) {
      final updated = existing.copyWith(
        smsSent: true,
        smsSentAt: 'Just Now',
      );
      _todayRecords[studentId] = updated;
      final index = _historyRecords.indexWhere((r) => r.studentId == studentId && r.date == updated.date);
      if (index != -1) {
        _historyRecords[index] = updated;
      }
    }
  }

  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_historyRecords);
  }
}
