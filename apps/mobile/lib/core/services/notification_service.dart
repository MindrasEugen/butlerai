import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() => _instance;
  
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;
  
  /// Initialize local notifications
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize timezone
    tz.initializeTimeZones();
    
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings(
          '@mipmap/ic_launcher', // Default icon
    );
    
    // iOS initialization
    final DarwinInitializationSettings initializationSettingsDarwin = 
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (id, title, body, payload) async {
            // Handle notification tap
          },
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
        final payload = details.payload;
        if (payload != null) {
          debugPrint('Local notification tapped with payload: $payload');
          // TODO: Navigate based on payload
        }
      },
    );
    
    _initialized = true;
  }
  
  /// Show a local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, String>? data,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    
    const AndroidNotificationDetails androidNotificationDetails = 
        AndroidNotificationDetails(
          'butlerai_notifications', // Channel ID
          'ButlerAI Notifications', // Channel name
          channelDescription: 'Notification channel for ButlerAI',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          enableVibration: true,
          playSound: true,
        );
    
    const DarwinNotificationDetails darwinNotificationDetails = 
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    
    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  /// Schedule a notification for a specific date/time
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    Map<String, String>? data,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    
    const AndroidNotificationDetails androidNotificationDetails = 
        AndroidNotificationDetails(
          'butlerai_notifications',
          'ButlerAI Notifications',
          channelDescription: 'Notification channel for ButlerAI',
          importance: Importance.high,
          priority: Priority.high,
        );
    
    const DarwinNotificationDetails darwinNotificationDetails = 
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    
    // Convert to timezone-aware DateTime
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );
    
    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
  
  /// Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
  
  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    if (!_initialized) {
      await initialize();
    }
    
    final bool? result = await _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    return result ?? false;
  }
  
  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
