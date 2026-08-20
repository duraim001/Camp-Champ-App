import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../core/config/supabase_config.dart';
import '../models/faculty_account_request.dart';
import '../models/teacher.dart';
import 'mock_teacher_service.dart';

class FacultyRequestService {
  static final FacultyRequestService _instance = FacultyRequestService._internal();
  factory FacultyRequestService() => _instance;
  FacultyRequestService._internal();

  final List<FacultyAccountRequestModel> _localRequests = [];

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // --- 1. SUBMIT REGISTRATION REQUEST ---
  Future<Map<String, dynamic>> submitRequest({
    required String fullName,
    required String email,
    required String phone,
    required String employeeId,
    required String department,
    required String designation,
    required String degree,
    required String username,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanPhone = phone.trim();
      final cleanEmployeeId = employeeId.trim().toUpperCase();
      final cleanUsername = username.trim();
      final cleanDegree = degree.trim().isNotEmpty ? degree.trim() : 'M.Tech';

      // Uniqueness check across local and remote
      final existingLocal = _localRequests.any(
        (r) => r.username.toLowerCase() == cleanUsername.toLowerCase() ||
               r.employeeId.toUpperCase() == cleanEmployeeId,
      );

      if (existingLocal) {
        return {
          'success': false,
          'error': 'Username or Employee ID already has a pending/existing request.'
        };
      }

      final passwordHash = hashPassword(password);
      final newRequest = FacultyAccountRequestModel(
        id: 'REQ-${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: cleanEmail,
        phone: cleanPhone,
        employeeId: cleanEmployeeId,
        department: department.trim(),
        designation: designation.trim(),
        degree: cleanDegree,
        username: cleanUsername,
        passwordHash: passwordHash,
        status: 'PENDING',
        requestedAt: DateTime.now(),
      );

      // Save to local cache
      _localRequests.insert(0, newRequest);

      // Save to Supabase DB if accessible
      try {
        await SupabaseConfig.client.from('faculty_account_requests').insert(newRequest.toJson());
      } catch (e) {
        debugPrint('Supabase insert faculty request warning: $e');
      }

      return {'success': true, 'request': newRequest};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- 2. FETCH REQUESTS (FOR ADMIN) ---
  Future<List<FacultyAccountRequestModel>> fetchRequests({String statusFilter = 'ALL'}) async {
    List<FacultyAccountRequestModel> requests = List.from(_localRequests);

    try {
      var query = SupabaseConfig.client.from('faculty_account_requests').select('*');
      if (statusFilter != 'ALL') {
        query = query.eq('status', statusFilter);
      }
      final response = await query.order('requested_at', ascending: false);
      final data = response as List<dynamic>;
      
      final remoteRequests = data.map((json) => FacultyAccountRequestModel.fromJson(json)).toList();

      // Merge remote requests without duplicates
      for (var r in remoteRequests) {
        if (!requests.any((req) => req.id == r.id || req.employeeId == r.employeeId)) {
          requests.add(r);
        }
      }
    } catch (e) {
      debugPrint('Error fetching faculty requests from Supabase: $e');
    }

    if (statusFilter == 'ALL') {
      return requests;
    }
    return requests.where((r) => r.status.toUpperCase() == statusFilter.toUpperCase()).toList();
  }

  // --- 3. APPROVE REQUEST ---
  Future<Map<String, dynamic>> approveRequest({
    required String requestId,
    required String adminId,
  }) async {
    try {
      final index = _localRequests.indexWhere((r) => r.id == requestId);
      FacultyAccountRequestModel? targetRequest;

      if (index != -1) {
        targetRequest = _localRequests[index].copyWith(
          status: 'APPROVED',
          reviewedAt: DateTime.now(),
          reviewedBy: adminId,
        );
        _localRequests[index] = targetRequest;
      }

      // Supabase update
      try {
        await SupabaseConfig.client.from('faculty_account_requests').update({
          'status': 'APPROVED',
          'reviewed_at': DateTime.now().toIso8601String(),
          'reviewed_by': adminId,
        }).eq('id', requestId);
      } catch (e) {
        debugPrint('Supabase approve request error: $e');
      }

      // Create active teacher account
      if (targetRequest != null) {
        final newTeacher = TeacherModel(
          id: targetRequest.employeeId,
          name: targetRequest.fullName,
          facultyId: targetRequest.employeeId,
          department: targetRequest.department,
          designation: targetRequest.designation,
          degree: targetRequest.degree,
          classAdvisor: '${targetRequest.department} Advisor',
          subjects: ['Core Engineering', 'Advanced Topics'],
          email: targetRequest.email,
          phone: targetRequest.phone,
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          status: 'Active',
        );

        MockTeacherService().registerTeacher(newTeacher);

        try {
          await SupabaseConfig.client.from('teachers').upsert({
            'id': newTeacher.id,
            'name': newTeacher.name,
            'faculty_id': newTeacher.facultyId,
            'department': newTeacher.department,
            'designation': newTeacher.designation,
            'degree': newTeacher.degree,
            'email': newTeacher.email,
            'phone': newTeacher.phone,
            'college': newTeacher.college,
            'location': newTeacher.location,
            'status': 'Active',
          });
        } catch (e) {
          debugPrint('Supabase teacher insert error: $e');
        }
      }

      return {'success': true, 'message': 'Faculty account approved successfully.'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- 4. REJECT REQUEST ---
  Future<Map<String, dynamic>> rejectRequest({
    required String requestId,
    required String adminId,
    required String reason,
  }) async {
    try {
      final index = _localRequests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        _localRequests[index] = _localRequests[index].copyWith(
          status: 'REJECTED',
          reviewedAt: DateTime.now(),
          reviewedBy: adminId,
          rejectionReason: reason.trim(),
        );
      }

      // Supabase update
      try {
        await SupabaseConfig.client.from('faculty_account_requests').update({
          'status': 'REJECTED',
          'reviewed_at': DateTime.now().toIso8601String(),
          'reviewed_by': adminId,
          'rejection_reason': reason.trim(),
        }).eq('id', requestId);
      } catch (e) {
        debugPrint('Supabase reject request error: $e');
      }

      return {'success': true, 'message': 'Faculty request rejected.'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- 5. AUTHENTICATE TEACHER WITH STATUS CHECK ---
  Future<Map<String, dynamic>> authenticateTeacher({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final inputHash = hashPassword(password.trim());

    // Search local requests first
    FacultyAccountRequestModel? match;
    try {
      match = _localRequests.firstWhere(
        (r) => (r.username.toLowerCase() == cleanUsername.toLowerCase() ||
                r.email.toLowerCase() == cleanUsername.toLowerCase() ||
                r.employeeId.toLowerCase() == cleanUsername.toLowerCase()),
      );
    } catch (_) {
      match = null;
    }

    // If not found locally, query Supabase
    if (match == null) {
      try {
        final response = await SupabaseConfig.client
            .from('faculty_account_requests')
            .select('*')
            .or('username.eq.$cleanUsername,email.eq.$cleanUsername,employee_id.eq.$cleanUsername')
            .maybeSingle();

        if (response != null) {
          match = FacultyAccountRequestModel.fromJson(response);
          _localRequests.add(match);
        }
      } catch (e) {
        debugPrint('Supabase query error: $e');
      }
    }

    if (match == null) {
      return {
        'success': false,
        'error': 'Invalid username or password.'
      };
    }

    // Verify password hash
    if (match.passwordHash != inputHash) {
      return {
        'success': false,
        'error': 'Invalid username or password.'
      };
    }

    // Verify Account Status
    if (match.status == 'PENDING') {
      return {
        'success': false,
        'status': 'PENDING',
        'error': 'Your faculty account is waiting for Admin approval.'
      };
    }

    if (match.status == 'REJECTED') {
      final reasonStr = (match.rejectionReason != null && match.rejectionReason!.isNotEmpty)
          ? ' Reason: ${match.rejectionReason}'
          : '';
      return {
        'success': false,
        'status': 'REJECTED',
        'error': 'Your faculty account request was rejected.$reasonStr'
      };
    }

    if (match.status == 'APPROVED') {
      final teacher = TeacherModel(
        id: match.employeeId,
        name: match.fullName,
        facultyId: match.employeeId,
        department: match.department,
        designation: match.designation,
        degree: match.degree,
        classAdvisor: '${match.department} Advisor',
        subjects: ['Core Engineering', 'Advanced Topics'],
        email: match.email,
        phone: match.phone,
        college: 'Sengunthar Engineering College',
        location: 'Tiruchengode, Tamil Nadu',
        status: 'Active',
      );
      MockTeacherService().registerTeacher(teacher);

      return {
        'success': true,
        'status': 'APPROVED',
        'userId': match.employeeId,
        'facultyName': match.fullName,
        'teacher': teacher,
      };
    }

    return {
      'success': false,
      'error': 'Invalid username or password.'
    };
  }
}

