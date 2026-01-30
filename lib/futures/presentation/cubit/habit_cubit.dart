import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hebipom/core/services/notivication_service.dart';
import 'package:hebipom/futures/domain/repo/habit_repo.dart';
import 'package:home_widget/home_widget.dart';
import '../../domain/entity/habit.dart';

class HabitCubit extends Cubit<List<Habit>> {
  final HabitRepo habitRepo;
  final NotificationService notificationService;
  HabitCubit(this.habitRepo, this.notificationService) : super([]) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    try {
      final habits = await habitRepo.getAllHabits();
      emit(habits);
      _updateWidget(habits);
      notificationService.alertFiveHourBeforeResetStreak(habits);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
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
    notificationService.cancelNotification(habitId + 10000);
  }

  Future<void> markHabitAsCompleted(int habitId) async {
    await habitRepo.markHabitAsCompleted(habitId);
    loadHabits();
  }

  Future<void> markHabitAsNotCompleted (int habitId) async {
    await habitRepo.markHabitAsUncompleted(habitId);
    loadHabits();
  }

  //! PERLU DIUPDATE
  Future<void> _updateWidget(List<Habit> habits) async {
    final habitsData = habits
        .map(
          (h) => {
            'id': h.id.toString(),
            'name': h.name,
            'isCompleted': h.isCompleted,
            'timeReminder': '${h.timeReminder.hour}:${h.timeReminder.minute}',
          },
        )
        .toList();

    await HomeWidget.saveWidgetData('habits_data', jsonEncode(habitsData));

    await HomeWidget.updateWidget(androidName: 'MyHomeWidget');
  }
}
