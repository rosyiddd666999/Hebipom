// futures/presentation/page/pomodoro/pomodoro_page.dart
// ignore_for_file: unused_import, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hebipom/core/utils/vectors.dart';
import 'package:hebipom/core/widgets/my_button.dart';
import 'package:hebipom/futures/presentation/cubit/habit_cubit.dart';
import 'package:hebipom/futures/domain/entity/habit.dart';
import 'package:hebipom/futures/presentation/cubit/pomodoro_cubit.dart';
import 'package:hebipom/futures/presentation/cubit/pomodoro_timer_ui/pomodoro_timer_ui_cubit.dart';
import 'package:hebipom/futures/domain/entity/pomodoro.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  // STATE UNTUK HABIT DAN PENGATURAN WAKTU (HANYA UNTUK INITIAL VIEW)
  int? _selectedHabitId;
  String _selectedHabitName = 'Fokus';

  int _timePomodoro = 25;
  int _timeSortBreak = 5;
  int _timeLongBreak = 15;
  int _session = 3;

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _startPomodoro() async {
    final cubit = context.read<PomodoroTimerUiCubit>();

    final id32Bit = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    // 1. Buat Pomodoro baru
    final newPomodoro = Pomodoro(
      id: id32Bit,
      name: _selectedHabitName,
      habitId: _selectedHabitId,
      timePomodoro: _timePomodoro,
      timeSortBreak: _timeSortBreak,
      timeLongBreak: _timeLongBreak,
      session: _session,
      completedCycles: 0,
      createdAt: DateTime.now(),
      isActive: true,
      currentPhaseIndex: 0,
      remainingSeconds: _timePomodoro * 60,
      lastUpdatedAt: DateTime.now(),
    );

    // 2. Simpan ke database
    await context.read<PomodoroCubit>().createPomodoro(newPomodoro);

    // 3. Start timer di cubit global
    await cubit.startNewTimer(Duration(minutes: _timePomodoro), newPomodoro);

    // 4. Refresh UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'P O M O D O R O',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<PomodoroTimerUiCubit, PomodoroTimerUiState>(
        listener: (context, state) {
          // Ketika pomodoro selesai secara otomatis
          if (state is PomodoroTimerUiRunComplete) {
            _handlePomodoroCompletion();
          }
        },
        child: BlocBuilder<PomodoroTimerUiCubit, PomodoroTimerUiState>(
          builder: (context, state) {
            // SKENARIO 1 & 3: Tidak ada timer aktif → Tampilkan initial view
            if (state is PomodoroTimerUiInitial ||
                state is PomodoroTimerUiRunComplete) {
              return _buildInitialView();
            }

            // SKENARIO 2: Timer sedang berjalan → Tampilkan timer view
            return _buildTimerView();
          },
        ),
      ),
    );
  }

  // Method untuk handle completion (dipanggil otomatis via listener)
  Future<void> _handlePomodoroCompletion() async {
    // Mark habit as completed jika ada habit yang dipilih
    if (_selectedHabitId != null) {
      await context.read<HabitCubit>().markHabitAsCompleted(_selectedHabitId!);
    }

    // Show dialog notification
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pomodoro Selesai'),
          content: Text(
            _selectedHabitId != null
                ? 'Pomodoro untuk $_selectedHabitName selesai. Habit telah ditandai sebagai selesai.'
                : 'Pomodoro selesai.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // Reset selection
    if (mounted) {
      setState(() {
        _selectedHabitId = null;
        _selectedHabitName = 'Fokus';
      });
    }
  }

  // --- SETTINGS SHEET ---
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildSettingsSheet(context),
    );
  }

  Widget _buildSettingsSheet(BuildContext context) {
    int tempTimePomodoro = _timePomodoro;
    int tempTimeSortBreak = _timeSortBreak;
    int tempTimeLongBreak = _timeLongBreak;
    int tempSession = _session;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'ATUR WAKTU',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              _buildTimeInput(
                setModalState,
                label: 'Waktu Fokus (menit)',
                value: tempTimePomodoro,
                onChanged: (newValue) => tempTimePomodoro = newValue,
              ),
              _buildTimeInput(
                setModalState,
                label: 'Istirahat Pendek (menit)',
                value: tempTimeSortBreak,
                onChanged: (newValue) => tempTimeSortBreak = newValue,
              ),
              _buildTimeInput(
                setModalState,
                label: 'Istirahat Panjang (menit)',
                value: tempTimeLongBreak,
                onChanged: (newValue) => tempTimeLongBreak = newValue,
              ),
              _buildTimeInput(
                setModalState,
                label: 'Siklus Fokus (sesi)',
                value: tempSession,
                onChanged: (newValue) => tempSession = newValue,
                isSession: true,
              ),
              const Spacer(),
              MyButton(
                label: 'SIMPAN',
                onPressed: () {
                  setState(() {
                    _timePomodoro = tempTimePomodoro;
                    _timeSortBreak = tempTimeSortBreak;
                    _timeLongBreak = tempTimeLongBreak;
                    _session = tempSession;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeInput(
    StateSetter setModalState, {
    required String label,
    required int value,
    required Function(int) onChanged,
    bool isSession = false,
  }) {
    final minStep = isSession ? 1 : 5;
    final maxLimit = isSession ? 8 : 60;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.red.shade300, size: 16),
                onPressed: value > minStep
                    ? () {
                        setModalState(() {
                          final newValue = value - (isSession ? 1 : 5);
                          onChanged(newValue.clamp(minStep, maxLimit));
                        });
                      }
                    : null,
              ),
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.green.shade300, size: 16),
                onPressed: value < maxLimit
                    ? () {
                        setModalState(() {
                          final newValue = value + (isSession ? 1 : 5);
                          onChanged(newValue.clamp(minStep, maxLimit));
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- HABIT SELECTION ---
  void _showHabitSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildHabitSelectionSheet(context),
    );
  }

  Widget _buildHabitSelectionSheet(BuildContext context) {
    return BlocBuilder<HabitCubit, List<Habit>>(
      builder: (context, state) {
        final habits = state;

        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Pilih Habit',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedHabitId = null;
                        _selectedHabitName = 'Fokus';
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Set as Default',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _selectedHabitId == null
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.green.shade300,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (habits.isEmpty)
                Center(
                  child: Text(
                    'Belum ada habit tersedia.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];

                      if (habit.isCompleted == false) {
                        return ListTile(
                          title: Text(
                            habit.name.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: _selectedHabitId == habit.id
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedHabitId = habit.id;
                              _selectedHabitName = habit.name;
                            });
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          title: Text(
                            habit.name.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(
                            'Terselesaikan',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Habit ini telah selesai.'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // --- INITIAL VIEW ---
  Widget _buildInitialView() {
    final initialDuration = Duration(minutes: _timePomodoro);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: _showHabitSelection,
                hoverColor: Colors.white10,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        _selectedHabitName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildTimerDisplay(
                remainingDuration: initialDuration,
                progress: 0.0,
                phaseIndex: 0,
                isRunning: false,
                isInitialState: true,
              ),
              const SizedBox(height: 40),
              MyButton(onPressed: _startPomodoro, label: 'MULAI'),
            ],
          ),
        ),
      ),
    );
  }

  // --- TIMER VIEW ---
  Widget _buildTimerView() {
    return BlocBuilder<PomodoroTimerUiCubit, PomodoroTimerUiState>(
      builder: (context, state) {
        final cubit = context.read<PomodoroTimerUiCubit>();

        final phaseLabel = state.currentPhaseIndex % 2 == 0
            ? _selectedHabitName
            : (state.currentPhaseIndex == cubit.phases.length - 1
                  ? 'Istirahat Panjang'
                  : 'Istirahat Pendek');

        final isCompleted = state is PomodoroTimerUiRunComplete;

        Duration totalPhaseDuration = Duration.zero;
        if (!isCompleted && state.currentPhaseIndex < cubit.phases.length) {
          totalPhaseDuration = cubit.phases[state.currentPhaseIndex];
        }

        final double progress = isCompleted
            ? 1.0
            : 1.0 -
                  (state.remaining.inMilliseconds /
                      totalPhaseDuration.inMilliseconds);

        final safeProgress = progress.clamp(0.0, 1.0);

        final isLastPhase = state.currentPhaseIndex == cubit.phases.length - 1;

        Future<void> completeAndReset() async {
          await cubit.forceComplete();
        }

        final playPauseIcon = state.isRunning ? Icons.pause : Icons.play_arrow;
        final playPauseOnPressed = state.isRunning ? cubit.pause : cubit.resume;

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCompleted)
                        Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        )
                      else
                        Icon(
                          state.currentPhaseIndex % 2 == 0
                              ? Icons.work_outline
                              : Icons.coffee_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      const SizedBox(width: 8),
                      if (isCompleted)
                        Text(
                          'Selesai',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      else
                        Text(
                          phaseLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTimerDisplay(
                    remainingDuration: state.remaining,
                    progress: safeProgress,
                    phaseIndex: state.currentPhaseIndex,
                    isRunning: state.isRunning,
                  ),
                  const SizedBox(height: 40),
                  if (isCompleted)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pomodoro untuk $_selectedHabitName Selesai!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedHabitId = null;
                              _selectedHabitName = 'Fokus';
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Mulai Ulang'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButton(
                          onPressed: () {
                            cubit.forceComplete();
                          },
                          icon: const Icon(Icons.stop),
                          label: '',
                          isPrimaryColor: false,
                        ),
                        const SizedBox(width: 24),
                        MyButton(
                          onPressed: playPauseOnPressed,
                          icon: Icon(playPauseIcon),
                          label: '',
                        ),
                        const SizedBox(width: 24),
                        MyButton(
                          onPressed: () {
                            if (isLastPhase) {
                              completeAndReset();
                            }
                            cubit.skip();
                          },
                          icon: Icon(
                            isLastPhase ? Icons.check : Icons.skip_next,
                          ),
                          label: '',
                          isPrimaryColor: false,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsButton() {
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: _showSettingsSheet,
        hoverColor: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Atur Waktu',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                Theme.of(context).brightness == Brightness.light
                    ? AppVectors.settingsDark
                    : AppVectors.settingsLight,
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay({
    required Duration remainingDuration,
    required double progress,
    required int phaseIndex,
    required bool isRunning,
    bool isInitialState = false,
  }) {
    final cubit = context.read<PomodoroTimerUiCubit>();
    final isCompleted = remainingDuration == Duration.zero && !isInitialState;
    
    final phaseColor = phaseIndex % 2 == 0
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCompleted ? "00:00" : formatDuration(remainingDuration),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 48,
                  letterSpacing: 5.0,
                ),
              ),
              const SizedBox(height: 8),
              if (!isInitialState)
                Text(
                  'Siklus: ${cubit.getCurrentCycleLabel()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              else
                _buildSettingsButton(),
            ],
          ),
        ],
      ),
    );
  }
}
