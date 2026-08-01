import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Service for Firebase initialization and FCM (Push Notifications) handling
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() => _instance;
  
  FirebaseService._internal();
  
  late final FirebaseMessaging _firebaseMessaging;
  
  /// Initialize Firebase Core
  Future<void> initialize() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Initialize Firebase Messaging
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // Request permission for notifications (iOS only, Android has auto-grant)
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _requestNotificationPermissions();
      }
      
      // Get and configure FCM token
      await _configureFcmToken();
      
      // Setup message handlers
      _setupMessageHandlers();
      
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }
  
  /// Request notification permissions (iOS)
  Future<void> _requestNotificationPermissions() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      debugPrint('Notification permissions: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('User denied notification permissions');
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }
  
  /// Configure FCM token
  Future<void> _configureFcmToken() async {
    try {
      // Get the FCM token
      String? token = await _firebaseMessaging.getToken();
      
      if (token != null) {
        debugPrint('FCM Token: $token');
        // TODO: Send token to your backend (Supabase) for user registration
        // await _saveTokenToBackend(token);
      } else {
        debugPrint('FCM Token is null');
      }
      
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Update token on your backend
        // await _updateTokenOnBackend(newToken);
      });
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }
  
  /// Setup foreground and background message handlers
  void _setupMessageHandlers() {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');
      // TODO: Show local notification for foreground messages
      // _showLocalNotification(message);
    });
    
    // Background message handler (when app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Background message opened app: ${message.notification?.title}');
      // TODO: Navigate to specific screen based on notification data
      // _handleNotificationNavigation(message.data);
    });
    
    // Handler for when app is launched from terminated state via notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App launched from terminated state: ${message.notification?.title}');
        // TODO: Navigate to specific screen based on notification data
        // _handleNotificationNavigation(message.data);
      }
    });
  }
  
  /// Get current FCM token
  Future<String?> getFcmToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }
  
  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
  
  /// Dispose the service
  void dispose() {
    // Cleanup if needed
  }
}
