part of 'pomodoro_timer_ui_cubit.dart';

abstract class PomodoroTimerUiState extends Equatable {
  final Duration remaining;
  final int currentPhaseIndex;
  final int completedCycles;
  final bool isRunning;

  const PomodoroTimerUiState({
    required this.remaining,
    required this.currentPhaseIndex,
    required this.completedCycles,
    required this.isRunning,
  });

  @override
  List<Object?> get props => [
    remaining,
    currentPhaseIndex,
    completedCycles,
    isRunning,
  ];
}

class PomodoroTimerUiInitial extends PomodoroTimerUiState {
  const PomodoroTimerUiInitial({
    required super.remaining,
    required super.currentPhaseIndex,
    required super.completedCycles,
    required super.isRunning,
  });
}

class PomodoroTimerUiRunInProgress extends PomodoroTimerUiState {
  const PomodoroTimerUiRunInProgress(
    Duration remaining,
    int currentPhaseIndex,
    int completedCycles,
  ) : super(
        remaining: remaining,
        currentPhaseIndex: currentPhaseIndex,
        completedCycles: completedCycles,
        isRunning: true,
      );
}

class PomodoroTimerUiRunPause extends PomodoroTimerUiState {
  const PomodoroTimerUiRunPause(
    Duration remaining,
    int currentPhaseIndex,
    int completedCycles,
  ) : super(
        remaining: remaining,
        currentPhaseIndex: currentPhaseIndex,
        completedCycles: completedCycles,
        isRunning: false,
      );
}

class PomodoroTimerUiRunComplete extends PomodoroTimerUiState {
  const PomodoroTimerUiRunComplete()
    : super(
        remaining: Duration.zero,
        currentPhaseIndex: -1,
        completedCycles: 0,
        isRunning: false,
      );
}
