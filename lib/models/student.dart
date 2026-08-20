class StudentModel {
  final String id;
  final String name;
  final String registerNumber;
  final String rollNumber;
  final String dateOfBirth;
  final String department;
  final String course;
  final String year;
  final String section;
  final String semester;
  final String college;
  final String location;
  final String email;
  final String phone;
  final double attendancePercentage;
  final String status;

  const StudentModel({
    required this.id,
    required this.name,
    required this.registerNumber,
    this.rollNumber = '',
    this.dateOfBirth = '',
    required this.department,
    required this.course,
    required this.year,
    required this.section,
    required this.semester,
    required this.college,
    required this.location,
    required this.email,
    required this.phone,
    required this.attendancePercentage,
    this.status = 'Active',
  });
}
