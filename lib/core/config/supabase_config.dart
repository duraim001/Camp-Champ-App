import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://exfixmqlcmsaegzuabgy.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_-z-1Y-pK5hJGKna2P9Ql-w_WS0us43k';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
