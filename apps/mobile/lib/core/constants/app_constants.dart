import 'package:flutter/foundation.dart';

/// App configuration constants
class AppConstants {
  // App info
  static const String appName = 'ButlerAI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Il tuo maggiordomo smart anti-sprechi';
  
  // Package info
  static const String packageName = 'com.butlerai.app';
  
  // Supabase configuration
  // These will be loaded from .env in production
  // For development, you can use hardcoded values
  static String get supabaseUrl => 
      String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://tuo-progetto.supabase.co');
  
  static String get supabaseAnonKey => 
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
  
  // Firebase configuration
  static String get fcmServerKey =>
      String.fromEnvironment('FCM_SERVER_KEY', defaultValue: 'AAAAxxxxxxx:APA91bxxxxxxxx...');
  
  // API endpoints
  static const String functionsUrl = 'https://tuo-progetto.supabase.co/functions/v1';
  
  // Mistral AI
  static String get mistralApiKey =>
      String.fromEnvironment('MISTRAL_API_KEY', defaultValue: 'tuo_api_key_mistral');
  
  static const String mistralVisionModel = 'pixtral-large-latest';
  static const String mistralTextModel = 'mistral-small-latest';
  
  // Notifications
  static const String defaultNotificationChannel = 'butlerai_notifications';
  static const int notificationOffset24h = 24;
  static const int notificationOffset48h = 48;
  static const int notificationOffset72h = 72;
  
  // Storage
  static const String storageBucket = 'butlerai';
  
  // Currency
  static const List<String> supportedCurrencies = ['EUR', 'USD', 'GBP'];
  static const String defaultCurrency = 'EUR';
  
  // Billing cycles
  static const List<String> billingCycles = ['daily', 'weekly', 'monthly', 'quarterly', 'yearly', 'usage'];
  
  // Subscription limits (Free plan)
  static const int freePlanMaxSubscriptions = 3;
  static const int freePlanMaxOcrScans = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);
  
  // Debug
  static const bool debugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: true);
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
  
  // Environment
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  
  /// Check if running in production
  static bool get isProduction => environment == 'production';
  
  /// Check if running in development
  static bool get isDevelopment => environment == 'development';
  
  /// Check if running in staging
  static bool get isStaging => environment == 'staging';
}

/// App theme constants
class AppTheme {
  static const String fontFamily = 'Inter';
  
  // Colors
  static const String primaryColor = '#6C5CE7';
  static const String secondaryColor = '#A29BFE';
  static const String accentColor = '#FD79A8';
  static const String successColor = '#00B894';
  static const String warningColor = '#FDCB6E';
  static const String errorColor = '#E17055';
  static const String backgroundColor = '#FAFAFA';
  static const String surfaceColor = '#FFFFFF';
  static const String textPrimaryColor = '#2D3436';
  static const String textSecondaryColor = '#636E72';
  static const String borderColor = '#DFE6E9';
}

/// Notification status constants
class NotificationStatus {
  static const String pending = 'pending';
  static const String sent = 'sent';
  static const String delivered = 'delivered';
  static const String read = 'read';
  static const String failed = 'failed';
}

/// Subscription status constants
class SubscriptionStatus {
  static const String active = 'active';
  static const String cancelled = 'cancelled';
  static const String paused = 'paused';
  static const String expired = 'expired';
  static const String trial = 'trial';
}

/// User plan tiers
class PlanTier {
  static const String free = 'free';
  static const String premium = 'premium';
  static const String enterprise = 'enterprise';
}
