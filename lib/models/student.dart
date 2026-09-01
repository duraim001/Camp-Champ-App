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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      registerNumber: json['register_number']?.toString() ?? json['registerNumber']?.toString() ?? '',
      rollNumber: json['roll_number']?.toString() ?? json['rollNumber']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? json['dateOfBirth']?.toString() ?? '',
      department: json['department']?.toString() ?? 'Artificial Intelligence and Data Science',
      course: json['course']?.toString() ?? 'B.TECH',
      year: json['year']?.toString() ?? '4th Year',
      section: json['section']?.toString() ?? 'A',
      semester: json['semester']?.toString() ?? 'VII',
      college: json['college']?.toString() ?? 'Sengunthar Engineering College',
      location: json['location']?.toString() ?? 'Tiruchengode, Tamil Nadu',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      attendancePercentage: (json['attendance_percentage'] as num?)?.toDouble() ??
          (json['attendancePercentage'] as num?)?.toDouble() ??
          90.0,
      status: json['status']?.toString() ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'register_number': registerNumber,
      'roll_number': rollNumber,
      'date_of_birth': dateOfBirth,
      'department': department,
      'course': course,
      'year': year,
      'section': section,
      'semester': semester,
      'college': college,
      'location': location,
      'email': email,
      'phone': phone,
      'attendance_percentage': attendancePercentage,
      'status': status,
    };
  }
}
