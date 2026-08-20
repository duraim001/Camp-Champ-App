import '../models/teacher.dart';
import 'faculty_request_service.dart';

class MockTeacherService {
  static final MockTeacherService _instance = MockTeacherService._internal();
  factory MockTeacherService() => _instance;
  MockTeacherService._internal();

  final List<TeacherModel> _teachers = [
    const TeacherModel(
      id: 'SEC-TCH-001',
      name: 'Mr. M. Preamkumar',
      facultyId: 'SEC-TCH-001',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Assistant Professor',
      degree: 'M.Tech',
      classAdvisor: '2nd Year AI&DS',
      subjects: ['Data Structures', 'Machine Learning'],
      email: 'preamkumar@sengunthar.ac.in',
      phone: '+91 90000 00002',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
      isPresent: true,
      attendancePercentage: 96.5,
      status: 'Active',
    ),
  ];

  void registerTeacher(TeacherModel teacher) {
    final index = _teachers.indexWhere((t) => t.facultyId.toLowerCase() == teacher.facultyId.toLowerCase() || t.id.toLowerCase() == teacher.id.toLowerCase());
    if (index != -1) {
      _teachers[index] = teacher;
    } else {
      _teachers.add(teacher);
    }
  }

  List<TeacherModel> getAllTeachers() {
    return List.from(_teachers);
  }

  Future<TeacherModel> getTeacherProfile(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final trimmedId = teacherId.trim().toLowerCase();

    // 1. Check local teacher list
    try {
      return _teachers.firstWhere(
        (t) => t.id.toLowerCase() == trimmedId ||
               t.facultyId.toLowerCase() == trimmedId ||
               t.name.toLowerCase() == trimmedId ||
               t.email.toLowerCase() == trimmedId,
      );
    } catch (_) {}

    // 2. Check approved faculty requests in FacultyRequestService
    final reqs = await FacultyRequestService().fetchRequests(statusFilter: 'APPROVED');
    for (final r in reqs) {
      if (r.employeeId.toLowerCase() == trimmedId ||
          r.username.toLowerCase() == trimmedId ||
          r.email.toLowerCase() == trimmedId ||
          r.fullName.toLowerCase() == trimmedId) {
        final teacher = TeacherModel(
          id: r.employeeId,
          name: r.fullName,
          facultyId: r.employeeId,
          department: r.department,
          designation: r.designation,
          degree: r.degree,
          classAdvisor: '${r.department} Advisor',
          subjects: ['Core Engineering', 'Advanced Topics'],
          email: r.email,
          phone: r.phone,
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          isPresent: true,
          attendancePercentage: 98.0,
          status: 'Active',
        );
        registerTeacher(teacher);
        return teacher;
      }
    }

    if (_teachers.isNotEmpty) {
      return _teachers.first;
    }

    return TeacherModel(
      id: teacherId.isNotEmpty ? teacherId : 'FACULTY-001',
      name: teacherId.isNotEmpty ? teacherId : 'Faculty Member',
      facultyId: teacherId.isNotEmpty ? teacherId : 'FACULTY-001',
      department: 'Engineering',
      designation: 'Assistant Professor',
      degree: 'M.Tech',
      subjects: ['Engineering'],
      email: 'faculty@sengunthar.ac.in',
      phone: '+91 90000 00000',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
    );
  }

  List<TeacherModel> searchTeachers(String query, {String? department}) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return List.from(_teachers);
    return _teachers.where((t) {
      final matchesQuery = t.name.toLowerCase().contains(q) || t.facultyId.toLowerCase().contains(q);
      final matchesDept = department == null || department == 'All' || t.department == department;
      return matchesQuery && matchesDept;
    }).toList();
  }

  Future<Map<String, dynamic>> getTeacherStats(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'totalStudents': 42,
      'todaysClasses': 4,
      'presentToday': 38,
      'absentToday': 4,
      'onlineClasses': 1,
    };
  }
}

