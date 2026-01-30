import '../entity/pomodoro.dart';

abstract class PomodoroRepo {
  Future<List<Pomodoro>> getAllPomodoros();
  Future<Pomodoro?> getPomodoroById(int pomodoroId);
  Future<void> createPomodoro(Pomodoro pomodoro);
  Future<void> updatePomodoro(Pomodoro pomodoro);
  Future<void> deletePomodoro(int pomodoroId);
}