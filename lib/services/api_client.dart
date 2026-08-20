import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'session_manager.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // Change this to your machine's local IP or backend URL if testing on physical mobile device
  static String baseUrl = kIsWeb
      ? 'http://localhost:8090'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://127.0.0.1:8090'
          : 'http://localhost:8090');

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  String? get authToken => _authToken ?? SessionManager().token;

  Map<String, String> _headers({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = authToken;
    if (requiresAuth && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // --- AUTHENTICATION ---
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: _headers(requiresAuth: false),
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(milliseconds: 1500));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        setAuthToken(data['token']);
        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {
          'success': false,
          'error': data['detail'] ?? 'Login failed. Please check credentials.'
        };
      }
    } catch (e) {
      debugPrint('ApiClient login error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> registerFaculty({
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
      final url = Uri.parse('$baseUrl/auth/register-faculty');
      final response = await http.post(
        url,
        headers: _headers(requiresAuth: false),
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'employee_id': employeeId,
          'department': department,
          'designation': designation,
          'degree': degree,
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(milliseconds: 1500));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['detail'] ?? 'Registration failed.'};
      }
    } catch (e) {
      debugPrint('ApiClient registerFaculty error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final url = Uri.parse('$baseUrl/auth/me');
      final response = await http.get(
        url,
        headers: _headers(requiresAuth: true),
      ).timeout(const Duration(milliseconds: 1500));

      if (response.statusCode == 200) {
        return {'success': true, 'user': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Failed to fetch user profile'};
      }
    } catch (e) {
      debugPrint('ApiClient getMe error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- FACULTY ACCOUNT REQUESTS (ADMIN) ---
  Future<List<dynamic>?> getFacultyRequests({String? statusFilter}) async {
    try {
      var uri = '$baseUrl/admin/faculty-requests';
      if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'ALL') {
        uri += '?status_filter=$statusFilter';
      }
      final url = Uri.parse(uri);
      final response = await http.get(
        url,
        headers: _headers(requiresAuth: true),
      ).timeout(const Duration(milliseconds: 1500));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('ApiClient getFacultyRequests error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> approveFacultyRequest(String requestId) async {
    try {
      final url = Uri.parse('$baseUrl/admin/faculty-requests/$requestId/approve');
      final response = await http.post(
        url,
        headers: _headers(requiresAuth: true),
      ).timeout(const Duration(milliseconds: 1500));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['detail'] ?? 'Approval failed'};
      }
    } catch (e) {
      debugPrint('ApiClient approveFacultyRequest error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> rejectFacultyRequest(String requestId, {String? reason}) async {
    try {
      final url = Uri.parse('$baseUrl/admin/faculty-requests/$requestId/reject');
      final response = await http.post(
        url,
        headers: _headers(requiresAuth: true),
        body: jsonEncode({'reason': reason ?? 'Application rejected.'}),
      ).timeout(const Duration(milliseconds: 1500));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['detail'] ?? 'Rejection failed'};
      }
    } catch (e) {
      debugPrint('ApiClient rejectFacultyRequest error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // --- TEACHERS ---
  Future<List<dynamic>?> getTeachers() async {
    try {
      final url = Uri.parse('$baseUrl/admin/teachers');
      final response = await http.get(
        url,
        headers: _headers(requiresAuth: true),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('ApiClient getTeachers error: $e');
      return null;
    }
  }
}
