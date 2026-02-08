import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hebipom/core/services/notification_service.dart';
import 'package:hebipom/futures/domain/repo/habit_repo.dart';
import 'package:home_widget/home_widget.dart';
import '../../domain/entity/habit.dart';

class HabitCubit extends Cubit<List<Habit>> {
  final HabitRepo habitRepo;
  final NotificationService notificationService;
  static const platform = MethodChannel('com.example.hebipom/permissions');

  HabitCubit(this.habitRepo, this.notificationService) : super([]) {
    loadHabits();
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'toggleHabit') {
        final habitId = call.arguments['habitId'] as String;
        await _toggleHabitFromWidget(habitId);
      }
    });
  }

  Future<void> loadHabits() async {
    try {
      final habits = await habitRepo.getAllHabits();
      emit(habits);
      _updateWidget(habits);
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<void> createHabit(Habit newHabit) async {
    await habitRepo.createHabit(newHabit);
    loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await habitRepo.updateHabit(habit);
    loadHabits();
  }

  Future<void> deleteHabit(int habitId) async {
    await habitRepo.deleteHabit(habitId);
    loadHabits();
    notificationService.cancelNotification(habitId);
    notificationService.cancelHabitAlertNotification(habitId);
  }

  Future<void> markHabitAsCompleted(int habitId) async {
    await habitRepo.markHabitAsCompleted(habitId);
    notificationService.cancelNotification(habitId);

    final habits = await habitRepo.getAllHabits();
    final habit = habits.firstWhere((h) => h.id == habitId);

    await notificationService.scheduleNotification(
      id: habitId,
      title: 'Habit Reminder: ${habit.name.toUpperCase()}',
      body: habit.spiritQuote ?? 'Time to work on your habit!',
      hour: habit.timeReminder.hour,
      minute: habit.timeReminder.minute,
      forceNextDay: true,
    );
    
    loadHabits();
  }

  Future<void> markHabitAsNotCompleted(int habitId) async {
    await habitRepo.markHabitAsUncompleted(habitId);
    loadHabits();
  }

  Future<void> _updateWidget(List<Habit> habits) async {
    final habitsData = habits
        .map(
          (h) => {
            'id': h.id.toString(),
            'name': h.name,
            'isCompleted': h.isCompleted,
            'timeReminder':
                '${h.timeReminder.hour.toString().padLeft(2, '0')}:${h.timeReminder.minute.toString().padLeft(2, '0')}',
          },
        )
        .toList();

    await HomeWidget.saveWidgetData('habits_data', jsonEncode(habitsData));
    await HomeWidget.updateWidget(androidName: 'MyHomeWidget');
  }

  Future<void> _toggleHabitFromWidget(String habitIdStr) async {
    try {
      final habitId = int.parse(habitIdStr);
      final habit = state.firstWhere((h) => h.id == habitId);

      if (habit.isCompleted) {
        await markHabitAsNotCompleted(habitId);
      } else {
        await markHabitAsCompleted(habitId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling habit from widget: $e');
      }
    }
  }
}
