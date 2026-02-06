import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import '../../futures/domain/entity/habit.dart';
import '../utils/habit_utils.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Function(Map<String, bool>)? onPermissionChanged;

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = "[$timestamp] $message";
    debugPrint(logEntry);
  }

  Future<bool> _checkNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    return await Permission.notification.isGranted;
  }

  Future<bool> _checkExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    return await Permission.scheduleExactAlarm.isGranted;
  }

  Future<bool> _checkBatteryOptimizationPermission() async {
    if (!Platform.isAndroid) return true;
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  Future<bool> _checkAutoStartPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      bool isAvailable = await isAutoStartAvailable ?? false;

      final prefs = await SharedPreferences.getInstance();
      bool confirmed = prefs.getBool('autostart_confirmed') ?? false;

      if (!isAvailable) return true;

      return confirmed;
    } catch (e) {
      log('Error checking auto-start status: $e');
      return true;
    }
  }

  Future<void> confirmAutoStartEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autostart_confirmed', true);
    log('Auto-start confirmed by user');
  }

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.notification.request();
    log('Notification permission: ${status.isGranted}');
    return status.isGranted;
  }

  Future<bool> requestBatteryOptimizationPermission() async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) {
      log('Battery optimization already ignored');
      return true;
    }

    status = await Permission.ignoreBatteryOptimizations.request();

    log('Battery optimization request status: $status');
    return status.isGranted;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.scheduleExactAlarm.status;
    if (status.isGranted) return true;

    status = await Permission.scheduleExactAlarm.request();

    if (!status.isGranted) {
      const intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        data: 'package:com.example.hebipom',
      );
      await intent.launch();
    }

    return status.isGranted;
  }

  Future<bool> requestAutoStartPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final isAvailable = await isAutoStartAvailable ?? false;
      if (!isAvailable) return true;

      await getAutoStartPermission();

      await confirmAutoStartEnabled();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> checkAllPermissions() async {
    Map<String, bool> results = {};

    if (Platform.isAndroid) {
      results['notification'] = await _checkNotificationPermission();
      results['exactAlarm'] = await _checkExactAlarmPermission();
      results['batteryOptimization'] =
          await _checkBatteryOptimizationPermission();
      results['autoStart'] = await _checkAutoStartPermission();
    } else {
      results['notification'] = true;
      results['exactAlarm'] = true;
      results['batteryOptimization'] = true;
      results['autoStart'] = true;
    }
    return results;
  }

  Future<void> initNotification() async {
    if (_isInitialized) {
      log('Notification service already initialized');
      return;
    }

    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
              log('Notification tapped (foreground): ${response.payload}');
            },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      _isInitialized = true;
      log('Notification service initialized successfully');

      final permissions = await checkAllPermissions();
      log('Current permissions: $permissions');

      if (permissions.values.any((granted) => !granted)) {
        log('Some permissions are not granted. Please request permissions.');
      }
    } catch (e) {
      log('Init error: $e');
      if (kDebugMode) {
        print('Init error: $e');
      }
      rethrow;
    }
  }

  NotificationDetails _notificationDetails(int id) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        id.toString(),
        'Hebipom Notifications',
        channelDescription: 'Habit reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        sound: const RawResourceAndroidNotificationSound('alarm_sound'),
        playSound: true,
        enableVibration: true,
        enableLights: true,
        fullScreenIntent: true,
        autoCancel: false,
        ongoing: false,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_isInitialized) {
      log('Notification Service not initialized.');
      if (kDebugMode) print('Notification Service not initialized.');
      return;
    }

    final permissions = await checkAllPermissions();
    if (!permissions['notification']! || !permissions['exactAlarm']!) {
      log('Missing required permissions for scheduling');
      throw Exception(
        'Missing permissions: notification=${permissions['notification']}, exactAlarm=${permissions['exactAlarm']}',
      );
    }

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    log('Scheduling notification #$id for: $scheduledDate');
    if (kDebugMode) {
      print('Notifikasi dijadwalkan pada: $scheduledDate');
    }

    try {
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _notificationDetails(id),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      log('Notification #$id scheduled successfully');
    } catch (e) {
      log('Failed to schedule notification #$id: $e');
      rethrow;
    }
  }
  // Di dalam NotificationService

  /// Menjadwalkan alert 5 jam sebelum reset untuk satu habit tertentu
  Future<void> scheduleStreakAlert(Habit habit) async {
    final now = tz.TZDateTime.now(tz.local);

    // 1. Tentukan Deadline (Tengah malam nanti/besok pagi jam 00:00)
    final deadline = tz.TZDateTime(tz.local, now.year, now.month, now.day + 1);

    // 2. Waktu Alert (19:00 atau 7 malam)
    final alertTime = deadline.subtract(const Duration(hours: 2));

    // 3. Batalkan jadwal lama (ID khusus streak: habit.id + 10000)
    await notificationsPlugin.cancel(habit.id + 10000);

    // 4. Jika habit SUDAH selesai hari ini, tidak perlu pasang alert untuk hari ini
    if (habit.isCompleted) return;

    try {
      if (alertTime.isBefore(now)) {
        // Jika sudah lewat jam 7 malam, munculkan notifikasi sekarang juga
        await notificationsPlugin.show(
          habit.id + 10000,
          'Streak Dalam Bahaya!',
          'Habit "${habit.name}" belum selesai. Segera selesaikan sebelum tengah malam!',
          _notificationDetails(habit.id + 10000),
        );
      } else {
        // Jika belum jam 7 malam, jadwalkan secara eksak
        await notificationsPlugin.zonedSchedule(
          habit.id + 10000,
          'Peringatan Streak',
          '5 Jam lagi streak "${habit.name}" kamu akan reset!',
          alertTime,
          _notificationDetails(habit.id + 10000),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents:
              DateTimeComponents.time, // Berulang setiap hari jam 7 malam
        );
      }
      log('Streak alert scheduled for ${habit.name} at $alertTime');
    } catch (e) {
      log('Error scheduling streak alert: $e');
    }
  }

  Future<void> showPomodoroProgressNotification(
    int pomodoroId,
    String phase,
    String timeRemaining,
    double progress,
  ) async {
    final androidDetails = AndroidNotificationDetails(
      'pomodoro_progress_channel',
      'Pomodoro Progress',
      channelDescription: 'Shows ongoing pomodoro timer',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: (progress * 100).toInt(),
      playSound: false,
      enableVibration: false,
    );

    final notificationId = pomodoroId % 2147483647;

    final notificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      notificationId,
      'Pomodoro Timer - $phase',
      timeRemaining,
      notificationDetails,
    );
  }

  Future<void> cancelPomodoroProgressNotification(int pomodoroId) async {
    final notificationId = pomodoroId % 2147483647;
    await notificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
    log('Cancelled notification #$id');
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    log('Cancelled all notifications');
  }

  Future<void> cancelHabitAlertNotification(int habitId) async {
    await notificationsPlugin.cancel(habitId + 10000);
    log('Cancelled streak alert for habit #$habitId');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await notificationsPlugin.pendingNotificationRequests();
    log('Pending notifications: ${pending.length}');
    for (var notif in pending) {
      log('  - ID ${notif.id}: ${notif.title}');
    }
    return pending;
  }

  Future<void> showPomodoroNotification(
    int id,
    String title,
    String message,
  ) async {
    await notificationsPlugin.show(
      id,
      title,
      message,
      _notificationDetails(id),
    );
  }

  Future<void> cancelPomodoroNotifications(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
