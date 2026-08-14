import '../models/teacher.dart';

class MockTeacherService {
  static final MockTeacherService _instance = MockTeacherService._internal();
  factory MockTeacherService() => _instance;
  MockTeacherService._internal();

  static const TeacherModel demoTeacher = TeacherModel(
    id: 'SEC-TCH-001',
    name: 'Karthik',
    facultyId: 'SEC-TCH-001',
    department: 'Computer Science & Engineering',
    designation: 'Assistant Professor',
    classAdvisor: '2nd Year CSE',
    subjects: ['Data Structures', 'Database Management Systems'],
    email: 'karthik@smartsec.demo',
    phone: '+91 90000 00002',
    college: 'Sengunthar Engineering College',
    location: 'Tiruchengode',
    isPresent: true,
    attendancePercentage: 96.5,
    status: 'Active',
  );

  List<TeacherModel> getAllTeachers() {
    return [demoTeacher];
  }

  Future<TeacherModel> getTeacherProfile(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return demoTeacher;
  }

  List<TeacherModel> searchTeachers(String query, {String? department}) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [demoTeacher];
    return [demoTeacher].where((t) {
      final matchesQuery = t.name.toLowerCase().contains(q) || t.facultyId.toLowerCase().contains(q);
      final matchesDept = department == null || department == 'All' || t.department == department;
      return matchesQuery && matchesDept;
    }).toList();
  }

  Future<Map<String, dynamic>> getTeacherStats(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'totalStudents': 42,
      'todaysClasses': 4,
      'presentToday': 38,
      'absentToday': 4,
      'onlineClasses': 1,
    };
  }
}
