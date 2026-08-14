enum MeetingStatus {
  requested,
  confirmed,
  rejected,
  cancelled,
  completed,
}

extension MeetingStatusExtension on MeetingStatus {
  String get label {
    switch (this) {
      case MeetingStatus.requested:
        return 'REQUESTED';
      case MeetingStatus.confirmed:
        return 'CONFIRMED';
      case MeetingStatus.rejected:
        return 'REJECTED';
      case MeetingStatus.cancelled:
        return 'CANCELLED';
      case MeetingStatus.completed:
        return 'COMPLETED';
    }
  }

  String get description {
    switch (this) {
      case MeetingStatus.requested:
        return 'Waiting for Teacher Confirmation';
      case MeetingStatus.confirmed:
        return 'Meeting Confirmed';
      case MeetingStatus.rejected:
        return 'Meeting Request Rejected';
      case MeetingStatus.cancelled:
        return 'Meeting Cancelled';
      case MeetingStatus.completed:
        return 'Meeting Completed';
    }
  }
}

class ParentTeacherMeetingModel {
  final String id;
  final String parentId;
  final String studentId;
  final String studentName;
  final String registerNumber;
  final String teacherId;
  final String teacherName;
  final String subject;
  final String date;
  final String startTime;
  final String endTime;
  final MeetingStatus status;
  final String meetingType; // 'Online - Google Meet', 'In-Person'
  final String notes;
  final String meetingLink;

  const ParentTeacherMeetingModel({
    required this.id,
    required this.parentId,
    required this.studentId,
    required this.studentName,
    required this.registerNumber,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = MeetingStatus.requested,
    this.meetingType = 'Online - Google Meet',
    this.notes = 'Discussion on academic progress and CIA 3 performance.',
    this.meetingLink = 'https://meet.google.com/ptm-sec-demo',
  });

  ParentTeacherMeetingModel copyWith({
    MeetingStatus? status,
    String? notes,
  }) {
    return ParentTeacherMeetingModel(
      id: id,
      parentId: parentId,
      studentId: studentId,
      studentName: studentName,
      registerNumber: registerNumber,
      teacherId: teacherId,
      teacherName: teacherName,
      subject: subject,
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: status ?? this.status,
      meetingType: meetingType,
      notes: notes ?? this.notes,
      meetingLink: meetingLink,
    );
  }
}
