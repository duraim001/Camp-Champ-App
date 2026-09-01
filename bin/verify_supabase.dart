import 'dart:convert';
import 'package:http/http.dart' as http;
import '../lib/core/config/supabase_config.dart';

Future<void> main() async {
  print('====================================================');
  print('SUPABASE CONNECTION DIAGNOSTIC TEST (FLUTTER APP)');
  print('====================================================');
  print('Checking configured credentials...');
  print('Supabase URL      : ${SupabaseConfig.supabaseUrl}');
  print('Supabase Anon Key : ${SupabaseConfig.supabaseAnonKey}');
  print('----------------------------------------------------');

  final url = Uri.parse('${SupabaseConfig.supabaseUrl}/rest/v1/students?select=*&limit=1');

  try {
    final response = await http.get(
      url,
      headers: {
        'apikey': SupabaseConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
        'Content-Type': 'application/json',
      },
    );

    print('HTTP Status Code : ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('STATUS: SUCCESS!');
      print('Connection to Supabase established successfully.');
      print('Records fetched (1 record):');
      if (data.isNotEmpty) {
        print(data.first);
      } else {
        print('Table is empty (0 records found).');
      }
    } else {
      print('STATUS: FAILED');
      print('Error Body: ${response.body}');
      _diagnoseError(response.statusCode, response.body);
    }
  } catch (e) {
    print('STATUS: NETWORK ERROR');
    print('Failed to connect to host: $e');
  }
}

void _diagnoseError(int statusCode, String body) {
  print('\n--- DIAGNOSIS ---');
  if (statusCode == 401 || statusCode == 403) {
    print('Issue Type: API Key or Authentication Failure');
    print('Explanation: Supabase rejected the request headers or API key authorization.');
  } else if (statusCode == 404) {
    print('Issue Type: Invalid URL or Table Not Found');
    print('Explanation: The table "students" does not exist in Supabase database or the URL path is incorrect.');
  } else if (statusCode == 42501 || body.contains('PGRST301') || body.contains('permission denied')) {
    print('Issue Type: Database Permissions / Row Level Security (RLS)');
    print('Explanation: Row Level Security (RLS) is enabled on table "students" without a read policy for public/anon key.');
  } else {
    print('Issue Type: Server Error ($statusCode)');
    print('Details: $body');
  }
}
