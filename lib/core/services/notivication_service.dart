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

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = "[$timestamp] $message";
    debugPrint(logEntry);
  }

  Future<Map<String, bool>> requestAllPermissions() async {
    Map<String, bool> results = {};

    if (Platform.isAndroid) {
      final notifStatus = await Permission.notification.request();
      results['notification'] = notifStatus.isGranted;
      log('Notification permission: ${notifStatus.isGranted}');

      final alarmStatus = await Permission.scheduleExactAlarm.status;
      if (!alarmStatus.isGranted) {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
        log('Opened exact alarm settings - waiting for user action...');

        await Future.delayed(const Duration(seconds: 2));
        final newAlarmStatus = await Permission.scheduleExactAlarm.status;
        results['exactAlarm'] = newAlarmStatus.isGranted;
        log('Exact alarm permission: ${newAlarmStatus.isGranted}');
      } else {
        results['exactAlarm'] = true;
        log('Exact alarm already granted');
      }

      final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
      if (!batteryStatus.isGranted) {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
          data: 'package:com.marimo.hebipom',
        );
        await intent.launch();
        log('Opened battery optimization settings');

        await Future.delayed(const Duration(seconds: 2));
        final newBatteryStatus =
            await Permission.ignoreBatteryOptimizations.status;
        results['batteryOptimization'] = newBatteryStatus.isGranted;
        log('Battery optimization ignored: ${newBatteryStatus.isGranted}');
      } else {
        results['batteryOptimization'] = true;
        log('Battery optimization already ignored');
      }
    }

    return results;
  }

  Future<Map<String, bool>> checkAllPermissions() async {
    Map<String, bool> results = {};

    if (Platform.isAndroid) {
      results['notification'] = await Permission.notification.isGranted;
      results['exactAlarm'] = await Permission.scheduleExactAlarm.isGranted;
      results['batteryOptimization'] =
          await Permission.ignoreBatteryOptimizations.isGranted;
    } else {
      results['notification'] = true;
      results['exactAlarm'] = true;
      results['batteryOptimization'] = true;
    }

    return results;
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
        // Streak masih aman, cancel alert jika ada
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

      // Jika alert time sudah lewat atau terlalu dekat, kirim notifikasi sekarang
      if (alertTime.isBefore(now)) {
        // Notifikasi immediate jika sudah lewat
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
      ongoing: true, // Membuat notifikasi persistent
      autoCancel: false,
      showProgress: true,
      maxProgress: 100,
      progress: (progress * 100).toInt(),
      playSound: false,
      enableVibration: false,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      pomodoroId, // ID unik per pomodoro
      'Pomodoro Timer - $phase',
      timeRemaining,
      notificationDetails,
    );
  }

  Future<void> cancelPomodoroProgressNotification(int pomodoroId) async {
    await notificationsPlugin.cancel(pomodoroId);
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
