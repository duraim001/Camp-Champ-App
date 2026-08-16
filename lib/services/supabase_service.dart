import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/parent.dart';
import '../models/admin.dart';
import '../models/announcement.dart';
import '../models/assignment.dart';
import '../models/attendance_record.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get _client => SupabaseConfig.client;

  // --- AUTHENTICATION ---
  Future<AuthResponse?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      debugPrint('Supabase signIn error: $e');
      rethrow;
    }
  }

  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? userMetadata,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: userMetadata,
      );
      return response;
    } catch (e) {
      debugPrint('Supabase signUp error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  // --- STUDENTS ---
  Future<List<StudentModel>> fetchStudents() async {
    try {
      final response = await _client.from('students').select('*');
      final data = response as List<dynamic>;
      return data.map((json) => StudentModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        registerNumber: json['register_number'] ?? '',
        department: json['department'] ?? '',
        course: json['course'] ?? '',
        year: json['year'] ?? '',
        section: json['section'] ?? '',
        semester: json['semester'] ?? '',
        college: json['college'] ?? '',
        location: json['location'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        attendancePercentage: (json['attendance_percentage'] as num?)?.toDouble() ?? 0.0,
        status: json['status'] ?? 'Active',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching students from Supabase: $e');
      return [];
    }
  }

  Future<void> upsertStudent(StudentModel student) async {
    try {
      await _client.from('students').upsert({
        'id': student.id,
        'name': student.name,
        'register_number': student.registerNumber,
        'department': student.department,
        'course': student.course,
        'year': student.year,
        'section': student.section,
        'semester': student.semester,
        'college': student.college,
        'location': student.location,
        'email': student.email,
        'phone': student.phone,
        'attendance_percentage': student.attendancePercentage,
        'status': student.status,
      });
    } catch (e) {
      debugPrint('Error upserting student in Supabase: $e');
    }
  }

  // --- TEACHERS ---
  Future<List<TeacherModel>> fetchTeachers() async {
    try {
      final response = await _client.from('teachers').select('*');
      final data = response as List<dynamic>;
      return data.map((json) => TeacherModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        facultyId: json['faculty_id'] ?? '',
        department: json['department'] ?? '',
        designation: json['designation'] ?? '',
        classAdvisor: json['class_advisor'] ?? '2nd Year CSE',
        subjects: List<String>.from(json['subjects'] ?? []),
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        college: json['college'] ?? '',
        location: json['location'] ?? '',
        isPresent: json['is_present'] ?? true,
        attendancePercentage: (json['attendance_percentage'] as num?)?.toDouble() ?? 96.5,
        status: json['status'] ?? 'Active',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching teachers from Supabase: $e');
      return [];
    }
  }

  // --- PARENTS ---
  Future<List<ParentModel>> fetchParents() async {
    try {
      final response = await _client.from('parents').select('*');
      final data = response as List<dynamic>;
      return data.map((json) => ParentModel(
        id: json['id']?.toString() ?? '',
        parentId: json['parent_id'] ?? 'SEC-PAR-001',
        name: json['name'] ?? '',
        relationship: json['relationship'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        emergencyContact: json['emergency_contact'] ?? '',
        address: json['address'] ?? '',
        childrenIds: List<String>.from(json['children_ids'] ?? []),
        studentId: json['student_id'] ?? '',
        studentName: json['student_name'] ?? '',
        registerNumber: json['register_number'] ?? '',
        status: json['status'] ?? 'Active',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching parents from Supabase: $e');
      return [];
    }
  }

  // --- ADMINS ---
  Future<List<AdminModel>> fetchAdmins() async {
    try {
      final response = await _client.from('admins').select('*');
      final data = response as List<dynamic>;
      return data.map((json) => AdminModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'Admin',
        designation: json['designation'] ?? 'Administrator',
        college: json['college'] ?? '',
        location: json['location'] ?? '',
        avatarUrl: json['avatar_url'] ?? '',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching admins from Supabase: $e');
      return [];
    }
  }

  // --- ANNOUNCEMENTS ---
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final response = await _client.from('announcements').select('*').order('created_at', ascending: false);
      final data = response as List<dynamic>;
      return data.map((json) => AnnouncementModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        date: json['date'] ?? '',
        audience: json['audience'] ?? 'All',
        status: json['status'] ?? 'Published',
      )).toList();
    } catch (e) {
      debugPrint('Error fetching announcements from Supabase: $e');
      return [];
    }
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _client.from('announcements').insert({
        'title': announcement.title,
        'content': announcement.content,
        'date': announcement.date,
        'audience': announcement.audience,
        'status': announcement.status,
      });
    } catch (e) {
      debugPrint('Error creating announcement in Supabase: $e');
    }
  }

  // --- ASSIGNMENTS ---
  Future<List<AssignmentModel>> fetchAssignments() async {
    try {
      final response = await _client.from('assignments').select('*');
      final data = response as List<dynamic>;
      return data.map((json) => AssignmentModel(
        id: json['id']?.toString() ?? '',
        teacherId: json['teacher_id'] ?? '',
        title: json['title'] ?? '',
        subject: json['subject'] ?? '',
        className: json['class_name'] ?? '',
        description: json['description'] ?? '',
        questions: json['questions'] ?? '',
        assignedDate: json['assigned_date'] ?? '',
        dueDate: json['due_date'] ?? '',
        maximumMarks: json['maximum_marks'] ?? 100,
        status: json['status'] ?? 'Active',
        submissionsCount: json['submissions_count'] ?? 0,
      )).toList();
    } catch (e) {
      debugPrint('Error fetching assignments from Supabase: $e');
      return [];
    }
  }

  // --- ATTENDANCE ---
  Future<void> recordAttendance(AttendanceRecord record) async {
    try {
      await _client.from('attendance_records').insert({
        'student_id': record.studentId,
        'student_name': record.studentName,
        'register_number': record.registerNumber,
        'teacher_id': record.teacherId,
        'class_id': record.classId,
        'subject_id': record.subjectId,
        'subject_name': record.subjectName,
        'date': record.date,
        'time': record.time,
        'status': record.status.name,
        'sms_sent': record.smsSent,
        'sms_sent_at': record.smsSentAt,
      });
    } catch (e) {
      debugPrint('Error recording attendance in Supabase: $e');
    }
  }
}
