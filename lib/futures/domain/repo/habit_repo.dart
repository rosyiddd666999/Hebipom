import '../entity/habit.dart';

abstract class HabitRepo {
  Future<List<Habit>> getAllHabits();
  Future<Habit?> getHabitById(int habitId);
  Future<void> createHabit(Habit newHabit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(int habitId);
  Future<void> markHabitAsCompleted(int habitId);
  Future<void> markHabitAsUncompleted(int habitId);
}