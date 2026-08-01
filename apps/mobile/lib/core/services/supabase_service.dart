import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase database operations
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() => _instance;
  
  SupabaseService._internal();
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  /// Get Supabase client
  SupabaseClient get client => _supabase;
  
  /// Test connection to Supabase
  Future<bool> testConnection() async {
    try {
      // Simple test query - in supabase_flutter 2.x, the result is direct
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
  
  /// Get user session
  Future<User?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        debugPrint('👤 Current user: ${user.email}');
      }
      return user;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }
  
  /// Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        debugPrint('🔑 User signed in: ${response.user!.email}');
        return response.user!;
      }
      return null;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }
  
  /// Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password, String? name) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );
      
      if (response.user != null) {
        debugPrint('📝 User signed up: ${response.user!.email}');
        return response.user!;
      }
      return null;
    } catch (e) {
      debugPrint('Error signing up: $e');
      return null;
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      debugPrint('🚪 User signed out');
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
  
  /// Sign in with Google (requires Google OAuth setup in Supabase)
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        Provider.google,
      );
      debugPrint('🔑 User signed in with Google');
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
    }
  }
  
  /// Get categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _supabase
          .from('category')
          .select('id, name, icon, is_custom, created_at')
          .order('name', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }
  
  /// Get catalog services (subscriptions with user_id = NULL)
  Future<List<Map<String, dynamic>>> getCatalogServices() async {
    try {
      final response = await _supabase
          .from('subscription')
          .select('id, title, category_id, price, currency, billing_cycle, notes')
          .is_('user_id', null)
          .order('title', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching catalog services: $e');
      return [];
    }
  }
  
  /// Get user subscriptions
  Future<List<Map<String, dynamic>>> getUserSubscriptions(String userId) async {
    try {
      final response = await _supabase
          .from('subscription')
          .select('id, title, category_id, price, currency, billing_cycle, next_renewal, status, notes')
          .eq('user_id', userId)
          .order('next_renewal', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching user subscriptions: $e');
      return [];
    }
  }
  
  /// Add or update a subscription
  Future<Map<String, dynamic>?> saveSubscription({
    required String userId,
    required String title,
    required String categoryId,
    required double price,
    required String currency,
    required String billingCycle,
    DateTime? nextRenewal,
    String? notes,
    String? id,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'title': title,
        'category_id': categoryId,
        'price': price,
        'currency': currency,
        'billing_cycle': billingCycle,
        'next_renewal': nextRenewal?.toIso8601String(),
        'status': 'active',
        'source': 'manual',
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (id != null) {
        // Update existing
        final response = await _supabase
            .from('subscription')
            .update(data)
            .eq('id', id)
            .select()
            .maybeSingle();
        
        if (response != null) {
          return response as Map<String, dynamic>;
        }
        return null;
      } else {
        // Insert new
        final response = await _supabase
            .from('subscription')
            .insert(data)
            .select()
            .maybeSingle();
        
        if (response != null) {
          return response as Map<String, dynamic>;
        }
        return null;
      }
    } catch (e) {
      debugPrint('Error saving subscription: $e');
      return null;
    }
  }
  
  /// Delete a subscription
  Future<bool> deleteSubscription(String id) async {
    try {
      await _supabase
          .from('subscription')
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting subscription: $e');
      return false;
    }
  }
  
  /// Mark subscription as cancelled
  Future<bool> cancelSubscription(String id) async {
    try {
      await _supabase
          .from('subscription')
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('id', id);
      
      return true;
    } catch (e) {
      debugPrint('Error cancelling subscription: $e');
      return false;
    }
  }
  
  /// Get recommendations for a cancelled subscription
  Future<List<Map<String, dynamic>>> getRecommendations(String subscriptionId) async {
    try {
      final response = await _supabase
          .from('recommendation')
          .select('id, suggested_service, price, currency, is_affiliate, link, url')
          .eq('cancelled_subscription_id', subscriptionId)
          .order('price', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching recommendations: $e');
      return [];
    }
  }
  
  /// Get user settings
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final response = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (response != null) {
        return response as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user settings: $e');
      return null;
    }
  }
  
  /// Save user settings
  Future<Map<String, dynamic>?> saveUserSettings({
    required String userId,
    int? notificationOffsets,
    String? currencyDef,
    String? theme,
    String? language,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'notification_offsets': notificationOffsets,
        'currency_def': currencyDef,
        'theme': theme,
        'language': language,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _supabase
          .from('user_settings')
          .upsert(data, onConflict: 'user_id')
          .select()
          .maybeSingle();
      
      if (response != null) {
        return response as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error saving user settings: $e');
      return null;
    }
  }
}
