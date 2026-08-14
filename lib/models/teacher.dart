class TeacherModel {
  final String id;
  final String name;
  final String facultyId;
  final String department;
  final String designation;
  final String classAdvisor;
  final List<String> subjects;
  final String email;
  final String phone;
  final String college;
  final String location;
  final bool isPresent;
  final double attendancePercentage;
  final String status; // 'Active', 'Inactive'

  const TeacherModel({
    required this.id,
    required this.name,
    required this.facultyId,
    required this.department,
    required this.designation,
    this.classAdvisor = '2nd Year CSE',
    required this.subjects,
    required this.email,
    required this.phone,
    required this.college,
    required this.location,
    this.isPresent = true,
    this.attendancePercentage = 96.5,
    this.status = 'Active',
  });

  String get subject => subjects.isNotEmpty ? subjects.join(', ') : 'Computer Science';
}
