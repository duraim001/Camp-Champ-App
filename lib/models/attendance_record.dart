enum AttendanceStatus {
  notMarked,
  present,
  absent,
}

extension AttendanceStatusExtension on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'PRESENT';
      case AttendanceStatus.absent:
        return 'ABSENT';
      case AttendanceStatus.notMarked:
        return 'NOT MARKED';
    }
  }
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String registerNumber;
  final String teacherId;
  final String classId;
  final String subjectId;
  final String subjectName;
  final String date;
  final String time;
  final AttendanceStatus status;
  final bool smsSent;
  final String? smsSentAt;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.registerNumber,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.date,
    required this.time,
    required this.status,
    this.smsSent = false,
    this.smsSentAt,
  });

  AttendanceRecord copyWith({
    AttendanceStatus? status,
    bool? smsSent,
    String? smsSentAt,
  }) {
    return AttendanceRecord(
      id: id,
      studentId: studentId,
      studentName: studentName,
      registerNumber: registerNumber,
      teacherId: teacherId,
      classId: classId,
      subjectId: subjectId,
      subjectName: subjectName,
      date: date,
      time: time,
      status: status ?? this.status,
      smsSent: smsSent ?? this.smsSent,
      smsSentAt: smsSentAt ?? this.smsSentAt,
    );
  }
}
