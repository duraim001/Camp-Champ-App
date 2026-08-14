class ExamModel {
  final String id;
  final String examType; // 'CIA 1', 'CIA 2', 'CIA 3', 'Semester'
  final String subject;
  final String date;
  final String time;
  final String room;

  const ExamModel({
    required this.id,
    required this.examType,
    required this.subject,
    required this.date,
    required this.time,
    required this.room,
  });
}
