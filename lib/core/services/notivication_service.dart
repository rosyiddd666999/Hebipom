import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../main.dart';
import '../../futures/domain/entity/habit.dart';
import '../utils/habit_utils.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // --- TAMBAHAN: Callback untuk notify UI saat permission berubah ---
  Function(Map<String, bool>)? onPermissionChanged;

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = "[$timestamp] $message";
    debugPrint(logEntry);
  }

  // --- IMPROVED: Check individual permission dengan detail ---
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

  // --- IMPROVED: Request dengan proper handling ---
  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.notification.request();
    log('Notification permission: ${status.isGranted}');
    return status.isGranted;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.scheduleExactAlarm.status;
    if (status.isGranted) {
      log('Exact alarm already granted');
      return true;
    }

    // Open settings
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
    log('Opened exact alarm settings');

    // Return false, akan di-check ulang saat app resume
    return false;
  }

  Future<bool> requestBatteryOptimizationPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isGranted) {
      log('Battery optimization already ignored');
      return true;
    }

    // Open settings dengan package name
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'package:com.marimo.hebipom', // Sesuaikan dengan package name Anda
    );
    await intent.launch();
    log('Opened battery optimization settings');

    // Return false, akan di-check ulang saat app resume
    return false;
  }

  // --- IMPROVED: Check all permissions tanpa delay ---
  Future<Map<String, bool>> checkAllPermissions() async {
    Map<String, bool> results = {};

    if (Platform.isAndroid) {
      results['notification'] = await _checkNotificationPermission();
      results['exactAlarm'] = await _checkExactAlarmPermission();
      results['batteryOptimization'] =
          await _checkBatteryOptimizationPermission();
    } else {
      results['notification'] = true;
      results['exactAlarm'] = true;
      results['batteryOptimization'] = true;
    }

    log('Current permissions: $results');
    return results;
  }

  // --- IMPROVED: Sequential request (satu per satu) ---
  Future<Map<String, bool>> requestAllPermissionsSequential() async {
    Map<String, bool> results = {};

    if (!Platform.isAndroid) {
      results['notification'] = true;
      results['exactAlarm'] = true;
      results['batteryOptimization'] = true;
      return results;
    }

    // Step 1: Notification
    results['notification'] = await requestNotificationPermission();

    // Step 2: Exact Alarm (buka settings, return immediately)
    results['exactAlarm'] = await requestExactAlarmPermission();

    // Step 3: Battery Optimization (buka settings, return immediately)
    results['batteryOptimization'] =
        await requestBatteryOptimizationPermission();

    return results;
  }

  // --- DEPRECATED: Old method dengan delay ---
  @Deprecated('Use requestAllPermissionsSequential instead')
  Future<Map<String, bool>> requestAllPermissions() async {
    return requestAllPermissionsSequential();
  }

  Future<void> openBatteryOptimizationSettings() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      );
      await intent.launch();
      log('Opened battery optimization settings page');
    }
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
          log('🔔 Notification tapped (foreground): ${response.payload}');
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      _isInitialized = true;
      log('🔧 Notification service initialized successfully');

      final permissions = await checkAllPermissions();
      log('Current permissions: $permissions');

      if (permissions.values.any((granted) => !granted)) {
        log('⚠️ Some permissions are not granted. Please request permissions.');
      }
    } catch (e) {
      log('❌ Init error: $e');
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
      log('❌ Notification Service not initialized.');
      if (kDebugMode) print('Notification Service not initialized.');
      return;
    }

    final permissions = await checkAllPermissions();
    if (!permissions['notification']! || !permissions['exactAlarm']!) {
      log('❌ Missing required permissions for scheduling');
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

    log('⏰ Scheduling notification #$id for: $scheduledDate');
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
      log('✅ Notification #$id scheduled successfully');
    } catch (e) {
      log('❌ Failed to schedule notification #$id: $e');
      rethrow;
    }
  }

  Future<void> alertFiveHourBeforeResetStreak(List<Habit> habits) async {
    for (final habit in habits) {
      if (habit.lastCompletedDate == null || !habit.isCompleted) {
        continue;
      }

      final shouldReset = HabitUtils.shouldResetStreak(
        habitFrequency: habit.habitFrequency,
        lastCompletedDate: habit.lastCompletedDate,
      );

      if (!shouldReset) {
        await cancelNotification(habit.id + 10000);
        continue;
      }

      final now = tz.TZDateTime.now(tz.local);
      final lastDay = HabitUtils.normalizeToDay(habit.lastCompletedDate!);

      tz.TZDateTime? deadlineTime;

      switch (habit.habitFrequency) {
        case 'daily':
          deadlineTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
          ).add(const Duration(days: 1));
          break;
        case 'thirdlyPerWeek':
        case 'weekly':
          deadlineTime = tz.TZDateTime(
            tz.local,
            lastDay.year,
            lastDay.month,
            lastDay.day,
          ).add(const Duration(days: 7, hours: 23, minutes: 59));
          break;
        default:
          continue;
      }

      final alertTime = deadlineTime.subtract(const Duration(hours: 5));

      if (alertTime.isBefore(now)) {
        await notificationsPlugin.show(
          habit.id + 10000,
          '⚠️ Streak Dalam Bahaya!',
          'Habitmu "${habit.name}" akan direset dalam ${deadlineTime.difference(now).inHours} jam!',
          _notificationDetails(habit.id + 10000),
        );
        log('🚨 Sent immediate streak alert for habit "${habit.name}"');
      } else {
        try {
          await notificationsPlugin.zonedSchedule(
            habit.id + 10000,
            '⚠️ Streak Dalam Bahaya!',
            'Habitmu "${habit.name}" akan direset dalam 5 jam. Segera selesaikan!',
            alertTime,
            _notificationDetails(habit.id + 10000),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
          log('✅ Scheduled streak alert for "${habit.name}" at $alertTime');
        } catch (e) {
          log('❌ Failed to schedule streak alert: $e');
        }
      }
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
    log('🗑️ Cancelled notification #$id');
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    log('🗑️ Cancelled all notifications');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final pending = await notificationsPlugin.pendingNotificationRequests();
    log('📋 Pending notifications: ${pending.length}');
    for (var notif in pending) {
      log('  - ID ${notif.id}: ${notif.title}');
    }
    return pending;
  }

  Future<void> testNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(seconds: 5));

    await notificationsPlugin.zonedSchedule(
      999999,
      'Test Notification',
      'Ini adalah test notification dari Hebipom',
      scheduledDate,
      _notificationDetails(999999),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    log('🧪 Test notification scheduled in 5 seconds');
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