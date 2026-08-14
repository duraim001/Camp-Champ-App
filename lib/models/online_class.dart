class OnlineClassModel {
  final String id;
  final String teacherId;
  final String subject;
  final String className;
  final String date;
  final String startTime;
  final String endTime;
  final String platform;
  final String meetingUrl;
  final String description;
  final String status; // 'LIVE', 'UPCOMING', 'COMPLETED'

  const OnlineClassModel({
    required this.id,
    required this.teacherId,
    required this.subject,
    required this.className,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.platform,
    this.meetingUrl = '',
    this.description = '',
    required this.status,
  });

  String get faculty => 'Dr. Ravi Kumar';
}
