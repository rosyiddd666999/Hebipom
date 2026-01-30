import 'package:isar_community/isar.dart';
import '../../domain/entity/pomodoro.dart';

part 'isar_pomodoro.g.dart';

@collection
class PomodoroIsar {
  Id id = Isar.autoIncrement;
  late String name;
  DateTime? createdAt;
  int? habitId;
  late int timePomodoro;
  late int timeSortBreak;
  late int timeLongBreak;
  late int session;
  late int completedCycles;
  late bool isActive;
  late int currentPhaseIndex;
  late int remainingSeconds;
  DateTime? lastUpdatedAt;

  Pomodoro toEntity() {
    return Pomodoro(
      id: id,
      name: name,
      habitId: habitId,
      createdAt: createdAt,
      timePomodoro: timePomodoro,
      timeSortBreak: timeSortBreak,
      timeLongBreak: timeLongBreak,
      session: session,
      completedCycles: completedCycles,
      isActive: isActive,
      currentPhaseIndex: currentPhaseIndex,
      remainingSeconds: remainingSeconds,
      lastUpdatedAt: lastUpdatedAt,
    );
  }

  static PomodoroIsar fromEntity(Pomodoro pomodoro) {
    return PomodoroIsar()
      ..id = pomodoro.id
      ..name = pomodoro.name
      ..habitId = pomodoro.habitId
      ..createdAt = pomodoro.createdAt
      ..timePomodoro = pomodoro.timePomodoro
      ..timeSortBreak = pomodoro.timeSortBreak
      ..timeLongBreak = pomodoro.timeLongBreak
      ..session = pomodoro.session
      ..completedCycles = pomodoro.completedCycles
      ..isActive = pomodoro.isActive
      ..currentPhaseIndex = pomodoro.currentPhaseIndex
      ..remainingSeconds = pomodoro.remainingSeconds
      ..lastUpdatedAt = pomodoro.lastUpdatedAt;
  }
}