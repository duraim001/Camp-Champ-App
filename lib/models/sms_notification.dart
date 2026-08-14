enum SmsStatus {
  pending,
  sent,
  failed,
}

class SmsNotificationModel {
  final String id;
  final String studentId;
  final String studentName;
  final String parentId;
  final String parentName;
  final String parentPhone;
  final String teacherId;
  final String subject;
  final String date;
  final String message;
  final SmsStatus status;
  final DateTime sentAt;

  const SmsNotificationModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.parentId,
    required this.parentName,
    required this.parentPhone,
    required this.teacherId,
    required this.subject,
    required this.date,
    required this.message,
    this.status = SmsStatus.sent,
    required this.sentAt,
  });
}
