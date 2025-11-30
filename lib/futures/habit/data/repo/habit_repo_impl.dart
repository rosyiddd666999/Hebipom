import 'package:flutter/foundation.dart';
import 'package:hebipom/futures/habit/data/model/isar_habit.dart';
import 'package:hebipom/futures/habit/domain/entity/habit.dart';
import 'package:isar_community/isar.dart';
import '../../../core/utils/habit_utils.dart';
import '../../domain/repo/habit_repo.dart';

class HabitRepoImpl implements HabitRepo {
  final Isar db;

  HabitRepoImpl(this.db);

  @override
  Future<List<Habit>> getAllHabits() async {
    final habits = await db.habitIsars.where()
      .sortByLastCompletedDate()
      .thenByTimeReminderMinute()
      .findAll();

    // Auto-reset habits yang perlu direset
    for (var habit in habits) {
      await _processHabitReset(habit);
    }

    // Fetch ulang setelah reset
    final updatedHabits = await db.habitIsars.where().findAll();
    return updatedHabits.map((h) => h.toEntity()).toList();
  }

  /// Process reset habit berdasarkan kondisi
  Future<void> _processHabitReset(HabitIsar habit) async {
    bool needsUpdate = false;

    // Check apakah perlu reset isCompleted
    if (HabitUtils.shouldResetCompleted(
      isCompleted: habit.isCompleted,
      lastCompletedDate: habit.lastCompletedDate,
      habitFrequency: habit.habitFrequency,
    )) {
      habit.isCompleted = false;
      needsUpdate = true;
    }

    // Check apakah perlu reset streak
    if (HabitUtils.shouldResetStreak(
      lastCompletedDate: habit.lastCompletedDate,
      habitFrequency: habit.habitFrequency,
    )) {
      habit.streak = 0;
      needsUpdate = true;
    }

    // Update jika ada perubahan
    if (needsUpdate) {
      await db.writeTxn(() async {
        await db.habitIsars.put(habit);
      });
    }
  }

  @override
  Future<void> createHabit(Habit newHabit) async {
    final habitIsar = HabitIsar.fromEntity(newHabit);
    return db.writeTxn(() async {
      await db.habitIsars.put(habitIsar);
    });
  }

  @override
  Future<void> updateHabit(Habit habit) {
    final habitIsar = HabitIsar.fromEntity(habit);
    return db.writeTxn(() async {
      await db.habitIsars.put(habitIsar);
    });
  }

  @override
  Future<void> deleteHabit(int habitId) async {
    await db.writeTxn(() => db.habitIsars.delete(habitId));
  }

  @override
  Future<void> markHabitAsCompleted(int habitId) async {
    await _incrementStreak(habitId);
  }

  @override
  Future<void> markHabitAsUncompleted(int habitId) async {
    await _decrementStreak(habitId);
  }

  Future<void> _incrementStreak(int habitId) async {
    final habit = await db.habitIsars.get(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    final today = HabitUtils.normalizeToDay(now);

    // Check apakah sudah completed hari ini
    if (habit.lastCompletedDate != null) {
      final lastDay = HabitUtils.normalizeToDay(habit.lastCompletedDate!);

      if (today.isAtSameMomentAs(lastDay)) {
        if (kDebugMode) {
          print('Habit already completed today');
        }
        return;
      }
    }

    // Hitung streak baru menggunakan utils
    final newStreak = HabitUtils.calculateNewStreak(
      currentStreak: habit.streak,
      lastCompletedDate: habit.lastCompletedDate,
      habitFrequency: habit.habitFrequency,
      completedAt: now,
    );

    // Update habit
    await db.writeTxn(() async {
      habit.streak = newStreak;
      habit.lastCompletedDate = now;
      habit.isCompleted = true;
      await db.habitIsars.put(habit);
    });
  }

  Future<void> _decrementStreak(int habitId) async {
    final habit = await db.habitIsars.get(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    final yesterday = HabitUtils.normalizeToDay(
      now.subtract(const Duration(days: 1)),
    );

    //reset lastCompletedBefore
    await db.writeTxn(() async {
      if (habit.streak == 0) {
        return;
      } else if (habit.streak > 0) {
        habit.streak -= 1;
      }
      habit.lastCompletedDate = yesterday;
      habit.isCompleted = false;
      await db.habitIsars.put(habit);
    });
  }
}
