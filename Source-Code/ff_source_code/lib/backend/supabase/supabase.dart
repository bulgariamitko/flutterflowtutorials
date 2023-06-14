import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';
export 'storage/storage.dart';

const _kSupabaseUrl = 'https://flbbrhrhqrffwapxlssu.supabase.co';
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsYmJyaHJocXJmZndhcHhsc3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY3MjkyODMsImV4cCI6MjAwMjMwNTI4M30.f4Ba_CEpmViYOQkQHrTN9jg6u_zgL3OKnL0hmhHCW7k';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
      );
}
