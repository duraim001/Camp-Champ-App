import 'package:flutter/foundation.dart';
import '../core/config/supabase_config.dart';
import '../models/teacher.dart';
import 'faculty_request_service.dart';
import 'api_client.dart';
import 'session_manager.dart';

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
      classAdvisor: '2nd Year AI&DS Advisor',
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
    final index = _teachers.indexWhere((t) =>
        t.facultyId.toLowerCase() == teacher.facultyId.toLowerCase() ||
        t.id.toLowerCase() == teacher.id.toLowerCase());
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
    final trimmedId = teacherId.trim().toLowerCase();

    // 1. Try fetching from FastAPI /auth/me or API
    try {
      final meResult = await ApiClient().getMe();
      if (meResult['success'] == true && meResult['user'] != null) {
        final u = meResult['user'];
        final t = TeacherModel(
          id: u['employee_id'] ?? u['username'] ?? 'TCH',
          name: u['name'] ?? 'Faculty Member',
          facultyId: u['employee_id'] ?? u['username'] ?? 'TCH',
          department: u['department'] ?? 'AI&DS',
          designation: u['designation'] ?? 'Assistant Professor',
          degree: u['degree'] ?? 'M.Tech',
          classAdvisor: '${u['department'] ?? "Engineering"} Advisor',
          subjects: ['Core Engineering', 'Advanced Topics'],
          email: u['email'] ?? 'faculty@sengunthar.ac.in',
          phone: '+91 90000 00002',
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          isPresent: true,
          attendancePercentage: 96.5,
          status: 'Active',
        );
        registerTeacher(t);
        return t;
      }
    } catch (e) {
      debugPrint('FastAPI getMe profile error: $e');
    }

    // 2. Query Supabase PostgreSQL teachers table
    try {
      final res = await SupabaseConfig.client
          .from('teachers')
          .select('*')
          .or('faculty_id.eq.$teacherId,id.eq.$teacherId,email.eq.$teacherId')
          .maybeSingle();

      if (res != null) {
        final t = TeacherModel(
          id: res['id'] ?? teacherId,
          name: res['name'] ?? teacherId,
          facultyId: res['faculty_id'] ?? teacherId,
          department: res['department'] ?? 'AI&DS',
          designation: res['designation'] ?? 'Assistant Professor',
          degree: res['degree'] ?? 'M.Tech',
          classAdvisor: '${res['department'] ?? "Engineering"} Advisor',
          subjects: ['Core Engineering', 'Advanced Topics'],
          email: res['email'] ?? '$teacherId@sengunthar.ac.in',
          phone: res['phone'] ?? '+91 90000 00002',
          college: res['college'] ?? 'Sengunthar Engineering College',
          location: res['location'] ?? 'Tiruchengode, Tamil Nadu',
          status: res['status'] ?? 'Active',
        );
        registerTeacher(t);
        return t;
      }
    } catch (e) {
      debugPrint('Supabase teacher profile query error: $e');
    }

    // 3. Check local registered teachers
    try {
      return _teachers.firstWhere(
        (t) =>
            t.id.toLowerCase() == trimmedId ||
            t.facultyId.toLowerCase() == trimmedId ||
            t.name.toLowerCase() == trimmedId ||
            t.email.toLowerCase() == trimmedId,
      );
    } catch (_) {}

    // 4. Check approved faculty requests in FacultyRequestService
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

    // 5. Fallback
    final currentSession = SessionManager();
    final name = currentSession.userName ?? (teacherId.isNotEmpty ? teacherId : 'Faculty Member');

    return TeacherModel(
      id: teacherId.isNotEmpty ? teacherId : 'SEC-TCH-001',
      name: name,
      facultyId: teacherId.isNotEmpty ? teacherId : 'SEC-TCH-001',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Assistant Professor',
      degree: 'M.Tech',
      subjects: ['Engineering'],
      email: '$teacherId@sengunthar.ac.in',
      phone: '+91 90000 00002',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
    );
  }

  List<TeacherModel> searchTeachers(String query, {String? department}) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return List.from(_teachers);
    return _teachers.where((t) {
      final matchesQuery =
          t.name.toLowerCase().contains(q) || t.facultyId.toLowerCase().contains(q);
      final matchesDept =
          department == null || department == 'All' || t.department == department;
      return matchesQuery && matchesDept;
    }).toList();
  }

  Future<Map<String, dynamic>> getTeacherStats(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return {
      'totalStudents': 42,
      'todaysClasses': 4,
      'presentToday': 38,
      'absentToday': 4,
      'onlineClasses': 1,
    };
  }
}
