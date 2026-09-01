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
      id: 'b244e619-27da-4ccb-9e2f-4380c78fb9c8',
      name: 'Mrs. Santhipriya S M.E.',
      facultyId: 'b244e619-27da-4ccb-9e2f-4380c78fb9c8',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Head of Department (HOD)',
      degree: 'M.E.',
      classAdvisor: 'AI&DS HOD',
      subjects: ['Artificial Intelligence', 'Machine Learning', 'Data Science'],
      email: 'santhipriyahod@gmail.com',
      phone: '+91 90000 00001',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
      isPresent: true,
      attendancePercentage: 100.0,
      status: 'Active',
    ),
    const TeacherModel(
      id: 'SEC-AIDS-COORD',
      name: 'M. Premkumar',
      facultyId: 'SEC-AIDS-COORD',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Department Coordinator',
      degree: 'M.E.',
      classAdvisor: 'AI&DS Department Coordinator',
      subjects: ['Artificial Intelligence', 'Data Science & ML'],
      email: 'aidscoordinator@sengunthar.ac.in',
      phone: '+91 90000 00003',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Tamil Nadu',
      isPresent: true,
      attendancePercentage: 100.0,
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

    if (trimmedId == 'b244e619-27da-4ccb-9e2f-4380c78fb9c8' ||
        trimmedId == 'sec-aids-hod' ||
        trimmedId == 'santhipriyahod@gmail.com' ||
        trimmedId.contains('santhipriya')) {
      return _teachers.first;
    }

    // 1. Try fetching from FastAPI /auth/me or API
    try {
      final meResult = await ApiClient().getMe();
      if (meResult['success'] == true && meResult['user'] != null) {
        final u = meResult['user'];
        final rawDept = u['department'] ?? 'AI&DS';
        final deptDisplay = (rawDept == 'AI&DS' || rawDept == 'AIDS')
            ? 'Artificial Intelligence and Data Science'
            : rawDept;

        final t = TeacherModel(
          id: u['employee_id'] ?? u['username'] ?? 'SEC-AIDS-COORD',
          name: u['name'] ?? 'M. Premkumar',
          facultyId: u['employee_id'] ?? u['username'] ?? 'SEC-AIDS-COORD',
          department: deptDisplay,
          designation: u['designation'] ?? 'Department Coordinator',
          degree: u['degree'] ?? 'M.E.',
          classAdvisor: '$deptDisplay Advisor',
          subjects: ['Artificial Intelligence', 'Data Science & ML'],
          email: u['email'] ?? 'aidscoordinator@sengunthar.ac.in',
          phone: '+91 90000 00003',
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          isPresent: true,
          attendancePercentage: 100.0,
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
        final rawDept = res['department'] ?? 'AI&DS';
        final deptDisplay = (rawDept == 'AI&DS' || rawDept == 'AIDS')
            ? 'Artificial Intelligence and Data Science'
            : rawDept;

        final t = TeacherModel(
          id: res['id'] ?? teacherId,
          name: res['name'] ?? teacherId,
          facultyId: res['faculty_id'] ?? teacherId,
          department: deptDisplay,
          designation: res['designation'] ?? 'Department Coordinator',
          degree: res['degree'] ?? 'M.E.',
          classAdvisor: '$deptDisplay Advisor',
          subjects: ['Artificial Intelligence', 'Data Science & ML'],
          email: res['email'] ?? '$teacherId@sengunthar.ac.in',
          phone: res['phone'] ?? '+91 90000 00003',
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
          subjects: ['Artificial Intelligence', 'Data Science & ML'],
          email: r.email,
          phone: r.phone,
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          isPresent: true,
          attendancePercentage: 100.0,
          status: 'Active',
        );
        registerTeacher(teacher);
        return teacher;
      }
    }

    // 5. Fallback
    final currentSession = SessionManager();
    final name = currentSession.userName ?? (teacherId.isNotEmpty ? teacherId : 'M. Premkumar');

    return TeacherModel(
      id: teacherId.isNotEmpty ? teacherId : 'SEC-AIDS-COORD',
      name: name,
      facultyId: teacherId.isNotEmpty ? teacherId : 'SEC-AIDS-COORD',
      department: 'Artificial Intelligence and Data Science',
      designation: 'Department Coordinator',
      degree: 'M.E.',
      subjects: ['Artificial Intelligence'],
      email: 'aidscoordinator@sengunthar.ac.in',
      phone: '+91 90000 00003',
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
