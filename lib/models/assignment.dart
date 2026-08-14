class AssignmentModel {
  final String id;
  final String teacherId;
  final String title;
  final String subject;
  final String className;
  final String description;
  final String questions;
  final String assignedDate;
  final String dueDate;
  final int maximumMarks;
  final String status; // 'Active', 'Closed'
  final int submissionsCount;

  const AssignmentModel({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.subject,
    required this.className,
    required this.description,
    required this.questions,
    required this.assignedDate,
    required this.dueDate,
    required this.maximumMarks,
    this.status = 'Active',
    this.submissionsCount = 0,
  });

  String get faculty => 'Dr. Ravi Kumar';
}
