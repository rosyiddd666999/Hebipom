// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entity/habit.dart';
import '../../../../domain/entity/pomodoro.dart';
import '../../../cubit/habit_cubit.dart';
import '../../../cubit/pomodoro_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar Tab
    const List<Tab> historyTabs = [Tab(text: 'Habit'), Tab(text: 'Pomodoro')];

    return DefaultTabController(
      length: historyTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HISTORY',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(onPressed: () => context.pop()),

          // TabBar ditempatkan di bagian bawah AppBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0), // Tinggi TabBar
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                // Gaya latar belakang TabBar agar terlihat menyatu dengan body
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TabBar(
                tabs: historyTabs,
                indicatorSize:
                    TabBarIndicatorSize.tab, // Indicator mengisi seluruh tab
                dividerColor: Theme.of(
                  context,
                ).colorScheme.background.withOpacity(0.0), // Warna pemisah tab
                // Gaya Indicator (Active Tab)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).colorScheme.primary, // Warna Aksen
                ),

                // Gaya Label (Teks Tab)
                labelColor: Theme.of(
                  context,
                ).colorScheme.onPrimary, // Warna teks di tab aktif
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurface, // Warna teks di tab tidak aktif
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),

                padding: EdgeInsets.zero, // Hapus padding default
                indicatorPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),

        // TabBarView untuk menampilkan konten setiap tab
        body: const TabBarView(
          children: [
            // Konten Tab 1: Riwayat Habit
            HabitHistoryTab(),

            // Konten Tab 2: Riwayat Pomodoro
            PomodoroHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class HabitHistoryTab extends StatelessWidget {
  const HabitHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, List<Habit>>(
      builder: (context, habits) {
        // 1. Filter hanya Habit yang pernah diselesaikan
        final completedHabits = habits
            .where((h) => h.lastCompletedDate != null)
            .toList();

        if (completedHabits.isEmpty) {
          return const Center(
            child: Text('Belum ada Habit yang diselesaikan.'),
          );
        }

        // 2. Kelompokkan berdasarkan tanggal terakhir diselesaikan
        final Map<DateTime, List<Habit>> groupedHabits = {};
        for (var habit in completedHabits) {
          final date = DateUtils.dateOnly(habit.lastCompletedDate!);
          if (!groupedHabits.containsKey(date)) {
            groupedHabits[date] = [];
          }
          groupedHabits[date]!.add(habit);
        }

        // 3. Urutkan tanggal dari yang terbaru
        final sortedDates = groupedHabits.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final habitsOnDate = groupedHabits[date]!;

            // Format tanggal untuk tampilan
            final String dateTitle = DateFormat(
              'EEEE, d MMMM yyyy',
            ).format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Tanggal
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    dateTitle,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Daftar Habit per Tanggal
                ...habitsOnDate
                    .map(
                      (habit) => Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: Text(habit.name.toUpperCase()),
                          subtitle: Text(
                            'Selesai pada: ${DateFormat('HH:mm').format(habit.lastCompletedDate!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Text(
                            'Streak: ${habit.streak}',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            );
          },
        );
      },
    );
  }
}

class PomodoroHistoryTab extends StatelessWidget {
  const PomodoroHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroCubit, List<Pomodoro>>(
      builder: (context, pomodoros) {
        // Urutkan dari yang terbaru (dibuat)
        final sortedPomodoros = pomodoros.toList();

        if (sortedPomodoros.isEmpty) {
          return const Center(
            child: Text('Belum ada sesi Pomodoro yang diselesaikan.'),
          );
        }

        // Kelompokkan Pomodoro berdasarkan tanggal pembuatan
        final Map<DateTime, List<Pomodoro>> groupedPomodoros = {};
        for (var p in sortedPomodoros) {
          final date = DateUtils.dateOnly(p.createdAt!);
          if (!groupedPomodoros.containsKey(date)) {
            groupedPomodoros[date] = [];
          }
          groupedPomodoros[date]!.add(p);
        }

        final sortedDates = groupedPomodoros.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final pomodorosOnDate = groupedPomodoros[date]!;

            final String dateTitle = DateFormat(
              'EEEE, d MMMM yyyy',
            ).format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Tanggal
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    dateTitle,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Daftar Pomodoro per Tanggal
                ...pomodorosOnDate.map((p) {
                  final totalTime =
                      (p.timePomodoro * p.session) +
                      (p.timeSortBreak * (p.session - 1)) +
                      (p.timeLongBreak);
                  return Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: ListTile(
                      leading: const Icon(Icons.timer, color: Colors.orange),
                      title: Text(p.name),
                      subtitle: Text(
                        'Waktu fokus: ${p.timePomodoro} m | Siklus: ${p.completedCycles}/${p.session}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Text(
                        'Total: $totalTime m',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }
}
