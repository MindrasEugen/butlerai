import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility class for environment configuration
class Environment {
  static bool _initialized = false;
  
  /// Initialize environment from .env file
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Load .env file
      await dotenv.load(fileName: ".env");
      
      // Debug output
      if (kDebugMode) {
        debugPrint('✓ Environment loaded');
      }
      
      _initialized = true;
    } catch (e) {
      // If .env file not found, use environment variables from system
      if (kDebugMode) {
        debugPrint('⚠️ .env file not found, using system environment variables');
      }
      _initialized = true;
    }
  }
  
  /// Get environment variable with optional default
  static String getString(String key, {String defaultValue = ''}) {
    return const String.fromEnvironment(key, defaultValue: defaultValue);
  }
  
  /// Get environment variable as boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = getString(key, defaultValue: defaultValue.toString());
    return value.toLowerCase() == 'true';
  }
  
  /// Get environment variable as integer
  static int getInt(String key, {int defaultValue = 0}) {
    final value = getString(key, defaultValue: defaultValue.toString());
    return int.tryParse(value) ?? defaultValue;
  }
  
  /// Get environment variable as double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = getString(key, defaultValue: defaultValue.toString());
    return double.tryParse(value) ?? defaultValue;
  }
  
  /// Check if environment is production
  static bool get isProduction => getString('ENVIRONMENT') == 'production';
  
  /// Check if environment is staging
  static bool get isStaging => getString('ENVIRONMENT') == 'staging';
  
  /// Check if environment is development
  static bool get isDevelopment => getString('ENVIRONMENT') == 'development' || getString('ENVIRONMENT').isEmpty;
}
