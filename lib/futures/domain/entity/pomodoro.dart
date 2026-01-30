class Pomodoro {
  final int id;
  final String name;
  final int? habitId;
  final DateTime? createdAt;
  final int timePomodoro;
  final int timeSortBreak;
  final int timeLongBreak;
  final int session;
  final int completedCycles;

  final bool isActive;
  final int currentPhaseIndex;
  final int remainingSeconds;
  final DateTime? lastUpdatedAt;

  Pomodoro({
    required this.id,
    required this.timePomodoro,
    required this.timeSortBreak,
    required this.timeLongBreak,
    required this.session,
    required this.completedCycles,
    required this.createdAt,
    this.name = 'fokus',
    this.habitId,
    this.isActive = false,
    this.currentPhaseIndex = 0,
    this.remainingSeconds = 0,
    this.lastUpdatedAt,
  });

  Pomodoro copyWith({
    int? id,
    String? name,
    int? habitId,
    int? timePomodoro,
    int? timeSortBreak,
    int? timeLongBreak,
    int? session,
    int? completedCycles,
    DateTime? createdAt,
    bool? isActive,
    int? currentPhaseIndex,
    int? remainingSeconds,
    DateTime? lastUpdatedAt,
  }) {
    return Pomodoro(
      id: id ?? this.id,
      name: name ?? this.name,
      habitId: habitId ?? this.habitId,
      timePomodoro: timePomodoro ?? this.timePomodoro,
      timeSortBreak: timeSortBreak ?? this.timeSortBreak,
      timeLongBreak: timeLongBreak ?? this.timeLongBreak,
      session: session ?? this.session,
      completedCycles: completedCycles ?? this.completedCycles,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
