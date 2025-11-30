import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../../domain/entity/habit.dart';

part 'isar_habit.g.dart';

@collection
class HabitIsar {
  Id id = Isar.autoIncrement;
  late String name;
  late int timeReminderHour;
  late int timeReminderMinute;
  late String habitFrequency;
  late bool isCompleted;
  late int streak;
  late String category;
  DateTime? lastCompletedDate;

  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      timeReminder: TimeOfDay(
        hour: timeReminderHour,
        minute: timeReminderMinute,
      ),
      habitFrequency: habitFrequency,
      isCompleted: isCompleted,
      streak: streak,
      category: category,
      lastCompletedDate: lastCompletedDate,
    );
  }

  static HabitIsar fromEntity(Habit habit) {
    return HabitIsar()
      ..id = habit.id
      ..name = habit.name
      ..timeReminderHour = habit.timeReminder.hour
      ..timeReminderMinute = habit.timeReminder.minute
      ..habitFrequency = habit.habitFrequency
      ..isCompleted = habit.isCompleted
      ..streak = habit.streak
      ..category = habit.category
      ..lastCompletedDate = habit.lastCompletedDate;
  }
}