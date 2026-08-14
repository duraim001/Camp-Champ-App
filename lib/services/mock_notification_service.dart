import '../models/notification.dart';

class MockNotificationService {
  static final MockNotificationService _instance = MockNotificationService._internal();
  factory MockNotificationService() => _instance;
  MockNotificationService._internal();

  final List<StudentNotificationModel> _notifications = [
    StudentNotificationModel(
      id: 'N001',
      title: 'CIA 2 Marks Published',
      message: 'Your CIA 2 internal examination marks for Semester VI have been published.',
      date: '10 Aug 2026',
      type: 'Academic',
      isRead: false,
    ),
    StudentNotificationModel(
      id: 'N002',
      title: 'Online Class Scheduled',
      message: 'Data Structures online class scheduled by Dr. Ravi Kumar today at 10:00 AM.',
      date: '11 Aug 2026',
      type: 'Class',
      isRead: false,
    ),
    StudentNotificationModel(
      id: 'N003',
      title: 'New Assignment Added',
      message: 'Data Structures Assignment 03 has been assigned. Due date: 17 August 2026.',
      date: '10 Aug 2026',
      type: 'Assignment',
      isRead: true,
    ),
    StudentNotificationModel(
      id: 'N004',
      title: 'Attendance Alert',
      message: 'Your overall attendance is currently 87.0%. Keep up good attendance above 85%.',
      date: '08 Aug 2026',
      type: 'Attendance',
      isRead: true,
    ),
  ];

  List<StudentNotificationModel> getNotifications() => _notifications;

  void markAsRead(String id) {
    for (var n in _notifications) {
      if (n.id == id) {
        n.isRead = true;
        break;
      }
    }
  }
}
