class StudentNotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final String type;
  bool isRead;

  StudentNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
  });
}
