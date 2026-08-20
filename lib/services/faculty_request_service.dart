import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../core/config/supabase_config.dart';
import '../models/faculty_account_request.dart';
import '../models/teacher.dart';
import 'mock_teacher_service.dart';
import 'api_client.dart';
import 'session_manager.dart';

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

      // 1. Try submitting through FastAPI backend
      final apiResult = await ApiClient().registerFaculty(
        fullName: fullName.trim(),
        email: cleanEmail,
        phone: cleanPhone,
        employeeId: cleanEmployeeId,
        department: department.trim(),
        designation: designation.trim(),
        degree: cleanDegree,
        username: cleanUsername,
        password: password,
      );

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

      // Save locally and sync to Supabase database
      _localRequests.removeWhere((r) => r.employeeId == cleanEmployeeId || r.username == cleanUsername);
      _localRequests.insert(0, newRequest);

      try {
        await SupabaseConfig.client.from('faculty_account_requests').upsert(newRequest.toJson());
      } catch (e) {
        debugPrint('Supabase insert faculty request warning: $e');
      }

      if (apiResult['success'] == true) {
        return {'success': true, 'request': newRequest, 'api': apiResult};
      }

      return {'success': true, 'request': newRequest};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- 2. FETCH REQUESTS (FOR ADMIN) ---
  Future<List<FacultyAccountRequestModel>> fetchRequests({String statusFilter = 'ALL'}) async {
    List<FacultyAccountRequestModel> requests = List.from(_localRequests);

    // 1. Try fetching from FastAPI backend
    try {
      final apiData = await ApiClient().getFacultyRequests(statusFilter: statusFilter);
      if (apiData != null && apiData.isNotEmpty) {
        for (var item in apiData) {
          final req = FacultyAccountRequestModel.fromJson(item as Map<String, dynamic>);
          if (!requests.any((r) => r.id == req.id || r.employeeId == req.employeeId)) {
            requests.add(req);
          } else {
            final idx = requests.indexWhere((r) => r.id == req.id || r.employeeId == req.employeeId);
            if (idx != -1) requests[idx] = req;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching requests from API: $e');
    }

    // 2. Query Supabase PostgreSQL
    try {
      var query = SupabaseConfig.client.from('faculty_account_requests').select('*');
      if (statusFilter != 'ALL') {
        query = query.eq('status', statusFilter);
      }
      final response = await query.order('requested_at', ascending: false);
      final data = response as List<dynamic>;
      
      final remoteRequests = data.map((json) => FacultyAccountRequestModel.fromJson(json)).toList();

      for (var r in remoteRequests) {
        if (!requests.any((req) => req.id == r.id || req.employeeId == r.employeeId)) {
          requests.add(r);
        } else {
          final idx = requests.indexWhere((req) => req.id == r.id || req.employeeId == r.employeeId);
          if (idx != -1) requests[idx] = r;
        }
      }
    } catch (_) {
      // Handled via backend API and local store
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
      // 1. Send approval transaction to FastAPI REST backend
      final apiResult = await ApiClient().approveFacultyRequest(requestId);

      // 2. Find request target
      final index = _localRequests.indexWhere((r) => r.id == requestId);
      FacultyAccountRequestModel? targetRequest;

      if (index != -1) {
        targetRequest = _localRequests[index].copyWith(
          status: 'APPROVED',
          reviewedAt: DateTime.now(),
          reviewedBy: adminId,
        );
        _localRequests[index] = targetRequest;
      } else {
        final allReqs = await fetchRequests();
        final found = allReqs.where((r) => r.id == requestId).toList();
        if (found.isNotEmpty) {
          targetRequest = found.first.copyWith(
            status: 'APPROVED',
            reviewedAt: DateTime.now(),
            reviewedBy: adminId,
          );
        }
      }

      // 3. Supabase update
      try {
        await SupabaseConfig.client.from('faculty_account_requests').update({
          'status': 'APPROVED',
          'reviewed_at': DateTime.now().toIso8601String(),
          'reviewed_by': adminId,
        }).eq('id', requestId);
      } catch (_) {
        // Ignored if table not initialized on remote Supabase
      }

      // 4. Create active permanent teacher account
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
            'email': newTeacher.email,
            'phone': newTeacher.phone,
            'college': newTeacher.college,
            'location': newTeacher.location,
            'status': 'Active',
          });
        } catch (e) {
          debugPrint('Supabase teacher insert note: $e');
        }
      }

      return {
        'success': true, 
        'message': 'Faculty account approved and created successfully',
        'api': apiResult
      };
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
      await ApiClient().rejectFacultyRequest(requestId, reason: reason);

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

    // 1. Try FastAPI REST API Login
    try {
      final loginRes = await ApiClient().login(
        username: cleanUsername,
        password: password.trim(),
      );

      if (loginRes['success'] == true && loginRes['user'] != null) {
        final userData = loginRes['user'];
        final teacherName = userData['name'] ?? cleanUsername;
        final dept = userData['department'] ?? 'AI&DS';
        final desig = userData['designation'] ?? 'Assistant Professor';
        final deg = userData['degree'] ?? 'M.Tech';
        final empId = userData['employee_id'] ?? cleanUsername;

        final teacher = TeacherModel(
          id: empId,
          name: teacherName,
          facultyId: empId,
          department: dept,
          designation: desig,
          degree: deg,
          classAdvisor: '$dept Advisor',
          subjects: ['Core Engineering', 'Advanced Topics'],
          email: userData['email'] ?? '$cleanUsername@sengunthar.ac.in',
          phone: '+91 90000 00002',
          college: 'Sengunthar Engineering College',
          location: 'Tiruchengode, Tamil Nadu',
          isPresent: true,
          attendancePercentage: 96.5,
          status: 'Active',
        );

        MockTeacherService().registerTeacher(teacher);
        SessionManager().setUser(
          role: 'Teacher',
          name: teacher.name,
          username: cleanUsername,
          token: loginRes['token'],
        );

        return {
          'success': true,
          'status': 'APPROVED',
          'userId': empId,
          'facultyName': teacher.name,
          'request': FacultyAccountRequestModel(
            id: empId,
            fullName: teacher.name,
            email: teacher.email,
            phone: teacher.phone,
            employeeId: empId,
            department: dept,
            designation: desig,
            degree: deg,
            username: cleanUsername,
            passwordHash: '',
            status: 'APPROVED',
            requestedAt: DateTime.now(),
          ),
          'teacher': teacher,
        };
      }
    } catch (e) {
      debugPrint('FastAPI login check error: $e');
    }

    // 2. Search local and Supabase DB
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
        'status': 'NOT_FOUND',
        'error': 'No faculty account or registration request found for this username.',
      };
    }

    final inputHash = hashPassword(password.trim());
    if (match.passwordHash.isNotEmpty && match.passwordHash != inputHash) {
      return {
        'success': false,
        'status': 'INVALID_PASSWORD',
        'error': 'Incorrect password. Please try again.',
      };
    }

    if (match.status.toUpperCase() == 'PENDING') {
      return {
        'success': false,
        'status': 'PENDING',
        'error': 'Your faculty account request is pending administrative approval.',
      };
    }

    if (match.status.toUpperCase() == 'REJECTED') {
      return {
        'success': false,
        'status': 'REJECTED',
        'error': 'Your request was rejected. Reason: ${match.rejectionReason ?? "Does not meet criteria"}',
      };
    }

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
      isPresent: true,
      attendancePercentage: 96.5,
      status: 'Active',
    );

    MockTeacherService().registerTeacher(teacher);
    SessionManager().setUser(
      role: 'Teacher',
      name: teacher.name,
      username: cleanUsername,
    );

    return {
      'success': true,
      'status': 'APPROVED',
      'userId': match.employeeId,
      'facultyName': match.fullName,
      'request': match,
      'teacher': teacher,
    };
  }
}
