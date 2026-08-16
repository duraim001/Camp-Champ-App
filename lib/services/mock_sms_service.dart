import '../models/sms_notification.dart';
import 'mock_attendance_service.dart';

class MockSmsService {
  static final MockSmsService _instance = MockSmsService._internal();
  factory MockSmsService() => _instance;
  MockSmsService._internal();

  final List<SmsNotificationModel> _sentNotifications = [];

  List<SmsNotificationModel> get sentNotifications => List.unmodifiable(_sentNotifications);

  Future<Map<String, dynamic>> sendParentAbsenceSms({
    required String studentId,
    required String studentName,
    required String parentId,
    required String parentName,
    required String parentPhone,
    required String teacherId,
    required String subject,
    required String date,
    required String message,
  }) async {
    // Simulate network delay for demo SMS dispatcher
    await Future.delayed(const Duration(milliseconds: 500));

    final notification = SmsNotificationModel(
      id: 'SMS-${DateTime.now().millisecondsSinceEpoch}',
      studentId: studentId,
      studentName: studentName,
      parentId: parentId,
      parentName: parentName,
      parentPhone: parentPhone,
      teacherId: teacherId,
      subject: subject,
      date: date,
      message: message,
      status: SmsStatus.sent,
      sentAt: DateTime.now(),
    );

    _sentNotifications.insert(0, notification);
    await MockAttendanceService().markSmsSent(studentId);

    return {
      'success': true,
      'message': 'Parent has been notified via SMS.',
      'notification': notification,
    };
  }

  Future<Map<String, dynamic>> sendBulkAbsenceSms({
    required List<Map<String, String>> absentStudents,
    required String teacherId,
    required String subject,
    required String date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    int count = 0;
    for (var s in absentStudents) {
      final notification = SmsNotificationModel(
        id: 'SMS-BULK-${DateTime.now().millisecondsSinceEpoch}-$count',
        studentId: s['studentId'] ?? '',
        studentName: s['studentName'] ?? '',
        parentId: s['parentId'] ?? '',
        parentName: s['parentName'] ?? 'Parent',
        parentPhone: s['parentPhone'] ?? '+91 90000 00000',
        teacherId: teacherId,
        subject: subject,
        date: date,
        message: 'Dear Parent/Guardian, your ward ${s['studentName']} was marked absent for $subject on $date. - Camp Champ',
        status: SmsStatus.sent,
        sentAt: DateTime.now(),
      );
      _sentNotifications.insert(0, notification);
      if (s['studentId'] != null) {
        await MockAttendanceService().markSmsSent(s['studentId']!);
      }
      count++;
    }

    return {
      'success': true,
      'sentCount': count,
      'message': 'Bulk SMS notifications sent to $count parents.',
    };
  }
}
