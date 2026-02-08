// futures/presentation/cubit/pomodoro_timer_ui/pomodoro_timer_ui_cubit.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/notification_service.dart';
import '../../../domain/entity/pomodoro.dart';
import '../../../domain/repo/pomodoro_repo.dart';

part 'pomodoro_timer_ui_state.dart';

class PomodoroTimerUiCubit extends Cubit<PomodoroTimerUiState> {
  List<Duration> phases;
  int pomodoroId;
  final PomodoroRepo pomodoroRepo;

  int currentPhaseIndex = 0;
  int completedCycles = 0;

  Timer? _timer;
  Timer? _persistTimer; // Timer untuk auto-save setiap 5 detik

  PomodoroTimerUiCubit({
    required this.phases,
    required this.pomodoroId,
    required this.pomodoroRepo,
  }) : super(
          PomodoroTimerUiInitial(
            remaining: phases.isNotEmpty ? phases[0] : Duration.zero,
            currentPhaseIndex: 0,
            completedCycles: 0,
            isRunning: false,
          ),
        );

  // INITIALIZE DARI DATABASE (UNTUK RESTORE)
  Future<void> initializeFromPomodoro(Pomodoro pomodoro) async {
    pomodoroId = pomodoro.id;
    currentPhaseIndex = pomodoro.currentPhaseIndex;
    completedCycles = pomodoro.completedCycles;
    
    // Generate phases dari settings
    phases = _generatePhasesFromPomodoro(pomodoro);

    if (pomodoro.isActive) {
      // Hitung elapsed time sejak terakhir update
      final now = DateTime.now();
      final lastUpdate = pomodoro.lastUpdatedAt ?? now;
      final elapsedSeconds = now.difference(lastUpdate).inSeconds;
      
      // Calculate remaining time
      int adjustedRemaining = pomodoro.remainingSeconds - elapsedSeconds;
      
      // Handle jika waktu sudah habis saat app tertutup
      while (adjustedRemaining <= 0 && currentPhaseIndex < phases.length - 1) {
        if (currentPhaseIndex % 2 == 0) {
          completedCycles++;
        }
        currentPhaseIndex++;
        adjustedRemaining += phases[currentPhaseIndex].inSeconds;
      }
      
      if (adjustedRemaining > 0) {
        final remainingDuration = Duration(seconds: adjustedRemaining);
        _startTicker(remainingDuration);
      } else {
        // Pomodoro selesai saat app tertutup
        await _completePomodoro();
      }
    }
  }

  List<Duration> _generatePhasesFromPomodoro(Pomodoro pomodoro) {
    List<Duration> newPhases = [];
    for (int i = 0; i < pomodoro.session; i++) {
      newPhases.add(Duration(minutes: pomodoro.timePomodoro));
      if (i < pomodoro.session - 1) {
        newPhases.add(Duration(minutes: pomodoro.timeSortBreak));
      } else {
        newPhases.add(Duration(minutes: pomodoro.timeLongBreak));
      }
    }
    return newPhases;
  }

  // START TIMER BARU
  Future<void> startNewTimer(
    Duration initialDuration,
    Pomodoro pomodoroDetails,
  ) async {
    pomodoroId = pomodoroDetails.id;
    phases = _generatePhasesFromPomodoro(pomodoroDetails);
    currentPhaseIndex = 0;
    completedCycles = 0;
    
    // Simpan state awal ke DB
    await _persistState(initialDuration, isActive: true);
    
    _startTicker(initialDuration);
    _startPersistTimer(); // Mulai auto-save
  }

  // TICKER TIAP DETIK
  void _startTicker(Duration duration) {
    emit(
      PomodoroTimerUiRunInProgress(
        duration,
        currentPhaseIndex,
        completedCycles,
      ),
    );

    _timer?.cancel();
    final startTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(startTime);
      final remaining = duration - elapsed;

      if (remaining.inSeconds <= 0) {
        _tick(Duration.zero);
        _timer?.cancel();
      } else {
        _tick(remaining);
      }
    });
  }

  // PERSIST TIMER SETIAP 5 DETIK
  void _startPersistTimer() {
    _persistTimer?.cancel();
    _persistTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (state.isRunning) {
        _persistState(state.remaining, isActive: true);
      }
    });
  }

  // SAVE STATE KE DATABASE
  Future<void> _persistState(Duration remaining, {required bool isActive}) async {
    try {
      final pomodoro = await pomodoroRepo.getPomodoroById(pomodoroId);
      if (pomodoro != null) {
        final updated = pomodoro.copyWith(
          isActive: isActive,
          currentPhaseIndex: currentPhaseIndex,
          remainingSeconds: remaining.inSeconds,
          completedCycles: completedCycles,
          lastUpdatedAt: DateTime.now(),
        );
        await pomodoroRepo.updatePomodoro(updated);
        
        // Update notifikasi progress
        if (isActive) {
          await _updateProgressNotification(remaining);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error persisting state: $e');
      }
    }
  }

  // UPDATE NOTIFIKASI PROGRESS
  Future<void> _updateProgressNotification(Duration remaining) async {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    
    final phaseLabel = currentPhaseIndex % 2 == 0 ? 'Fokus' : 'Istirahat';
    
    await NotificationService().showPomodoroProgressNotification(
      pomodoroId,
      phaseLabel,
      '$minutes:$seconds',
      _calculateOverallProgress(),
    );
  }

  double _calculateOverallProgress() {
    if (phases.isEmpty) return 0.0;
    
    int totalSeconds = 0;
    int completedSeconds = 0;
    
    for (int i = 0; i < phases.length; i++) {
      totalSeconds += phases[i].inSeconds;
      if (i < currentPhaseIndex) {
        completedSeconds += phases[i].inSeconds;
      } else if (i == currentPhaseIndex) {
        final phaseDuration = phases[i].inSeconds;
        final remaining = state.remaining.inSeconds;
        completedSeconds += (phaseDuration - remaining);
      }
    }
    
    return totalSeconds > 0 ? completedSeconds / totalSeconds : 0.0;
  }

  // HANDLE 1 DETIK LEWAT
  void _tick(Duration remaining) async {
    if (remaining.inSeconds <= 0) {
      // Fase selesai
      if (currentPhaseIndex % 2 == 0) {
        completedCycles++;
      }

      await _showPhaseCompletionNotification();

      if (currentPhaseIndex < phases.length - 1) {
        currentPhaseIndex++;
        await _persistState(phases[currentPhaseIndex], isActive: true);
        _startTicker(phases[currentPhaseIndex]);
      } else {
        await _completePomodoro();
      }
    } else {
      emit(
        PomodoroTimerUiRunInProgress(
          remaining,
          currentPhaseIndex,
          completedCycles,
        ),
      );
    }
  }

  // PAUSE
  Future<void> pause() async {
    if (state.isRunning) {
      _timer?.cancel();
      _persistTimer?.cancel();
      
      await _persistState(state.remaining, isActive: false);
      await NotificationService().cancelPomodoroProgressNotification(pomodoroId);
      
      emit(
        PomodoroTimerUiRunPause(
          state.remaining,
          currentPhaseIndex,
          completedCycles,
        ),
      );
    }
  }

  // RESUME
  Future<void> resume() async {
    if (!state.isRunning) {
      await _persistState(state.remaining, isActive: true);
      _startTicker(state.remaining);
      _startPersistTimer();
    }
  }

  // SKIP FASE
  Future<void> skip() async {
    _timer?.cancel();

    if (currentPhaseIndex % 2 == 0) {
      completedCycles++;
    }

    if (currentPhaseIndex < phases.length - 1) {
      currentPhaseIndex++;
      await _persistState(phases[currentPhaseIndex], isActive: true);
      _startTicker(phases[currentPhaseIndex]);
    } else {
      await _completePomodoro();
    }
  }

  // COMPLETE POMODORO
  Future<void> _completePomodoro() async {
    _timer?.cancel();
    _persistTimer?.cancel();

    await NotificationService().cancelPomodoroProgressNotification(pomodoroId);
    
    final pomodoro = await pomodoroRepo.getPomodoroById(pomodoroId);
    if (pomodoro != null) {
      final completed = pomodoro.copyWith(
        isActive: false,
        completedCycles: completedCycles,
      );
      await pomodoroRepo.updatePomodoro(completed);
    }

    emit(const PomodoroTimerUiRunComplete());
  }

  // FORCE COMPLETE (STOP BUTTON)
  Future<void> forceComplete() async {
    await _completePomodoro();
  }

  // NOTIFIKASI SETIAP FASE SELESAI
  Future<void> _showPhaseCompletionNotification() async {
    String phaseTitle;
    String phaseBody;

    if (currentPhaseIndex % 2 == 0) {
      phaseTitle = "Sesi Kerja Selesai!";
      phaseBody = "Waktu istirahat. Sesi selesai: $completedCycles";
    } else {
      phaseTitle = "Istirahat Selesai!";
      phaseBody = "Saatnya kembali bekerja!";
    }

    await NotificationService().showPomodoroNotification(
      DateTime.now().millisecondsSinceEpoch % 1000000,
      phaseTitle,
      phaseBody,
    );
  }

  String getCurrentCycleLabel() {
    final totalPhases = phases.length;
    final maxCycles = (totalPhases + 1) ~/ 2;

    if (currentPhaseIndex % 2 == 0) {
      final cycleNumber = (currentPhaseIndex ~/ 2) + 1;
      return '$cycleNumber dari $maxCycles';
    } else {
      final isLongBreak = currentPhaseIndex == totalPhases - 1;
      final breakType = isLongBreak ? 'Panjang' : 'Pendek';
      return 'Istirahat $breakType';
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _persistTimer?.cancel();
    return super.close();
  }
}