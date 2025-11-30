import 'package:flutter/material.dart';

class Habit {
  final int id;
  final String name;
  final TimeOfDay timeReminder;
  final String habitFrequency;
  final bool isCompleted;
  final int streak;
  final String category;
  DateTime? lastCompletedDate;

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
    required this.timeReminder,
    required this.habitFrequency,
    this.streak = 0,
    this.category = 'default',
    this.lastCompletedDate,
  });

  Habit copyWith({
    int? id,
    String? name,
    TimeOfDay? timeReminder,
    String? habitFrequency,
    bool? isCompleted,
    int? streak,
    String? category,
    DateTime? lastCompletedDate,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      timeReminder: timeReminder ?? this.timeReminder,
      habitFrequency: habitFrequency ?? this.habitFrequency,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
      category: category ?? this.category,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}