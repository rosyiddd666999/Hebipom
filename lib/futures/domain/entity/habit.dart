import 'package:flutter/material.dart';

class Habit {
  final int id;
  final String name;
  final String? spiritQuote;
  final TimeOfDay timeReminder;
  final String habitFrequency;
  final bool isCompleted;
  final int streak;
  final String category;
  final String priority;
  final List<DateTime> completedDates;
  DateTime? lastCompletedDate;

  Habit({
    required this.id,
    required this.name,
    this.spiritQuote,
    this.isCompleted = false,
    required this.timeReminder,
    required this.habitFrequency,
    this.streak = 0,
    this.category = 'default',
    this.priority = 'do',
    this.completedDates = const [],
    this.lastCompletedDate,
  });

  Habit copyWith({
    int? id,
    String? name,
    String? spiritQuote,
    TimeOfDay? timeReminder,
    String? habitFrequency,
    bool? isCompleted,
    int? streak,
    String? category,
    String? priority,
    List<DateTime>? completedDates,
    DateTime? lastCompletedDate,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      spiritQuote: spiritQuote ?? this.spiritQuote,
      timeReminder: timeReminder ?? this.timeReminder,
      habitFrequency: habitFrequency ?? this.habitFrequency,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      completedDates: completedDates ?? this.completedDates,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
  
  bool isCompletedOnDate(DateTime date) {
    final targetDay = DateTime(date.year, date.month, date.day);
    return completedDates.any((completedDate) {
      final completedDay = DateTime(
        completedDate.year,
        completedDate.month,
        completedDate.day,
      );
      return completedDay.isAtSameMomentAs(targetDay);
    });
  }
}