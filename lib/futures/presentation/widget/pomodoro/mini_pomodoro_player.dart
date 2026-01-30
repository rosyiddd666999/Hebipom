// futures/presentation/widget/pomodoro/mini_pomodoro_player.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/pomodoro_timer_ui/pomodoro_timer_ui_cubit.dart';

class MiniPomodoroPlayer extends StatelessWidget {
  const MiniPomodoroPlayer({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroTimerUiCubit, PomodoroTimerUiState>(
      builder: (context, state) {
        // Jangan tampilkan mini player jika tidak ada timer aktif
        if (state is PomodoroTimerUiInitial || state is PomodoroTimerUiRunComplete) {
          return FloatingActionButton(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              context.goNamed('pomodoro');
            },
            child: const Icon(Icons.timer_outlined),
          );
        }

        final cubit = context.read<PomodoroTimerUiCubit>();
        
        // Hitung progress untuk circular indicator
        final totalPhaseDuration = cubit.phases.isNotEmpty && 
                                   state.currentPhaseIndex < cubit.phases.length
            ? cubit.phases[state.currentPhaseIndex]
            : Duration.zero;
        
        final progress = totalPhaseDuration.inSeconds > 0
            ? 1.0 - (state.remaining.inSeconds / totalPhaseDuration.inSeconds)
            : 0.0;
        
        final safeProgress = progress.clamp(0.0, 1.0);

        // Warna berdasarkan fase (Fokus vs Istirahat)
        final phaseColor = state.currentPhaseIndex % 2 == 0
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.tertiary;

        return GestureDetector(
          onTap: () {
            // Navigasi ke PomodoroPage saat diklik
            context.goNamed('pomodoro');
          },
          child: SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Progress Indicator
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: safeProgress,
                    strokeWidth: 4,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
                  ),
                ),
                
                // Container untuk inner content
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon play/pause kecil
                      Icon(
                        state.isRunning ? Icons.pause : Icons.play_arrow,
                        size: 20,
                        color: phaseColor,
                      ),
                      const SizedBox(height: 2),
                      // Timer text
                      Text(
                        _formatDuration(state.remaining),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}