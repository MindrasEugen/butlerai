import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase database operations
/// Note: Full implementation will be added after F0-T15 is completed
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() => _instance;
  
  SupabaseService._internal();
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  /// Get Supabase client
  SupabaseClient get client => _supabase;
  
  /// Test connection to Supabase - F0-T15
  Future<bool> testConnection() async {
    try {
      final response = await _supabase
          .from('category')
          .select('id, name')
          .limit(1);
      
      debugPrint('✓ Supabase connection successful');
      if (response.isNotEmpty) {
        debugPrint('  First category: ${response.first['name']}');
      } else {
        debugPrint('  No categories found (database might be empty)');
      }
      return true;
    } catch (e) {
      debugPrint('✗ Supabase connection failed: $e');
      return false;
    }
  }
}
