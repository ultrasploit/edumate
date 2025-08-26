import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    
    // Set local timezone - you can change this to your specific timezone
    // For Sri Lanka: tz.getLocation('Asia/Colombo')
    // For auto-detection, you could use a package like 'flutter_native_timezone'
    tz.setLocalLocation(tz.getLocation('Asia/Colombo'));

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid
    );

    // Initialize the plugin
    final bool? initialized = await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (initialized == true) {
      // Request permissions
      await _requestPermissions();
      
      // Create notification channel
      await _createNotificationChannel();
      
      _isInitialized = true;
      debugPrint('Notifications initialized successfully');
    } else {
      debugPrint('Failed to initialize notifications');
    }
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      debugPrint('Notification permission granted: $granted');
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_channel_id',
      'Daily Notifications',
      description: 'Daily Notification Channel',
      importance: Importance.max,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
      debugPrint('Notification channel created');
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        showWhen: true,
      )
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    // Ensure notifications are initialized
    if (!_isInitialized) {
      await initNotification();
    }

    try {
      await notificationPlugin.show(id, title, body, notificationDetails());
      debugPrint('Notification shown: $title');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<String> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {

    if (!_isInitialized) {
      await initNotification();
    }

    // Check if the scheduled date is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('Cannot schedule notification in the past');
      return 'Invalid scheduled time!';
    }

    try {
      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        payload: scheduledDate.toIso8601String(),
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      
      return 'Success';
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      return 'Error';
    }

    // notificationPlugin.periodicallyShow(id, title, body, repeatInterval, notificationDetails, androidScheduleMode: androidScheduleMode)
  }

  // Cancel a specific scheduled notification
  Future<void> cancelNotification(int id) async {
    try {
      await notificationPlugin.cancel(id);
      debugPrint('Notification cancelled: $id');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  // Get all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await notificationPlugin.pendingNotificationRequests();
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    try {
      await notificationPlugin.cancelAll();
      debugPrint('All notifications cancelled');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }

  // Helper method to check if permissions are granted
  Future<bool> hasPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }
    return false;
  }

  // Method to manually request permissions
  Future<bool> requestPermissions() async {
    await _requestPermissions();
    return await hasPermissions();
  }
}