class TimetableEntryModel {
  final String id;
  final String day; // 'Monday', 'Tuesday', ...
  final String period;
  final String timeSlot;
  final String subject;
  final String faculty;
  final String room;

  const TimetableEntryModel({
    this.id = '',
    required this.day,
    this.period = '1st Period',
    required this.timeSlot,
    required this.subject,
    required this.faculty,
    required this.room,
  });
}
