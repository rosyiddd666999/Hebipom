// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/core/configs/themes/themes.dart';
import 'package:hebipom/core/widgets/my_button.dart';
import 'package:hebipom/futures/presentation/widget/habit/edit_habit_page.dart';
import 'package:intl/intl.dart';
import 'package:hebipom/futures/presentation/cubit/habit_cubit.dart';

import '../../../../core/utils/vectors.dart';
import '../../../domain/entity/habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  final Map<String, String> lightCategories = {
    'study': AppVectors.studyLight,
    'work': AppVectors.workLight,
    'exercise': AppVectors.exerciseLight,
    'health': AppVectors.healthLight,
    'sleep': AppVectors.sleepLight,
    'read': AppVectors.readLight,
    'write': AppVectors.writeLight,
    'drink': AppVectors.drinkLight,
    'saving': AppVectors.savingLight,
    'other': AppVectors.otherLight,
  };

  final Map<String, String> darkCategories = {
    'study': AppVectors.studyDark,
    'work': AppVectors.workDark,
    'exercise': AppVectors.exerciseDark,
    'health': AppVectors.healthDark,
    'sleep': AppVectors.sleepDark,
    'read': AppVectors.readDark,
    'write': AppVectors.writeDark,
    'drink': AppVectors.drinkDark,
    'saving': AppVectors.savingDark,
    'other': AppVectors.otherDark,
  };

  final Map<String, String> priorityTitles = {
    '1': 'DO',
    '2': 'SCHEDULE',
    '3': 'DELEGATE',
    '4': 'ELIMINATE',
  };
  final Map<String, String> priorityValues = {
    '1': 'You will do immediately',
    '2': 'Set a time to do the habit',
    '3': 'Try to delegate the habit',
    '4': 'Try to eliminate the habit',
  };

  final Map<String, Color> priorityLightIcons = {
    '1': ThemeHabit.habitCompnentLightVariant1,
    '2': ThemeHabit.habitCompnentLightVariant2,
    '3': ThemeHabit.habitCompnentLightVariant3,
    '4': ThemeHabit.habitCompnentLightVariant4,
  };

  final Map<String, Color> priorityDarkIcons = {
    '1': ThemeHabit.habitCompnentDarkVariant1,
    '2': ThemeHabit.habitCompnentDarkVariant2,
    '3': ThemeHabit.habitCompnentDarkVariant3,
    '4': ThemeHabit.habitCompnentDarkVariant4,
  };

  HabitDetailPage({super.key, required this.habit});

  // Method untuk menghitung completion rate
  String _calculateCompletionRate(Habit habit) {
    if (habit.completedDates.isEmpty) {
      return "0%";
    }

    // Cari tanggal pertama dan terakhir completed
    final sortedDates = [...habit.completedDates]..sort();
    final firstDate = sortedDates.first;
    final now = DateTime.now();

    // Hitung total hari sejak pertama kali completed hingga sekarang
    final totalDays = now.difference(firstDate).inDays + 1;

    // Hindari pembagian dengan 0
    if (totalDays <= 0) return "0%";

    // Hitung persentase (jumlah hari completed / total hari)
    final rate = (habit.completedDates.length / totalDays) * 100;

    // Format dengan 1 desimal
    return "${rate.toStringAsFixed(1)}%";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Dibungkus BlocBuilder agar tampilan update otomatis saat state Cubit berubah
    return BlocBuilder<HabitCubit, List<Habit>>(
      builder: (context, habits) {
        // Mencari data habit terbaru dari list state berdasarkan ID
        final currentHabit = habits.firstWhere(
          (h) => h.id == habit.id,
          orElse: () => habit,
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(
              currentHabit.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.edit, size: 24, color: Colors.green.shade500),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditHabitPage(habit: habit),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? darkCategories[currentHabit.category]!
                        : lightCategories[currentHabit.category]!,
                    height: 80,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '"${currentHabit.spiritQuote}"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  // Row Statistik Utama
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        "Current Streak",
                        "${currentHabit.streak}",
                        currentHabit.isCompleted
                            ? SvgPicture.asset(
                                AppVectors.flameActive,
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                AppVectors.flameNonactive,
                                width: 24,
                                height: 24,
                              ),
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        "Status",
                        currentHabit.isCompleted ? "SELESAI" : "PENDING",
                        currentHabit.isCompleted
                            ? Icon(Icons.done, color: Colors.green.shade300)
                            : Icon(
                                Icons.history,
                                color: Colors.yellow.shade300,
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REMINDER DETAILS",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Card Informasi Detail
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withOpacity(
                            0.3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              Icons.priority_high_rounded,
                              priorityTitles[currentHabit.priority]!,
                              priorityValues[currentHabit.priority]!,
                              true,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.access_time_rounded,
                              "Waktu Reminder",
                              currentHabit.timeReminder.format(context),
                              false,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.calendar_today_rounded,
                              "Frekuensi",
                              currentHabit.habitFrequency,
                              false,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.event_available_rounded,
                              "Terakhir Selesai",
                              currentHabit.lastCompletedDate != null
                                  ? DateFormat(
                                      'EEEE, d MMM yyyy',
                                    ).format(currentHabit.lastCompletedDate!)
                                  : "Belum pernah",
                              false,
                            ),
                          ],
                        ),
                      ),

                      // SECTION STATISTIK BARU
                      const SizedBox(height: 20),
                      Text(
                        "STATISTICS",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Card Statistik
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withOpacity(
                            0.3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              Icons.check_circle_outline_rounded,
                              "Total Hari Completed",
                              "${currentHabit.streak} hari",
                              false,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.trending_up_rounded,
                              "Completion Rate",
                              _calculateCompletionRate(currentHabit),
                              false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          floatingActionButton: // 3. Action Button
          currentHabit.isCompleted
              ? MyButton(
                  onPressed: () {
                    // Memanggil showDialog agar Alert muncul
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Batalkan Selesai'),
                        content: const Text(
                          'Anda yakin ingin mengubah status habit ini menjadi pending?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<HabitCubit>()
                                  .markHabitAsNotCompleted(currentHabit.id);
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                  label: "PENDING",
                  isPrimaryColor: false,
                  icon: const Icon(Icons.history),
                  isSquare: false,
                )
              : MyButton(
                  onPressed: () {
                    context.read<HabitCubit>().markHabitAsCompleted(
                      currentHabit.id,
                    );
                  },
                  label: "SELESAI",
                  isPrimaryColor: true,
                  icon: const Icon(Icons.done),
                  isSquare: false,
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  // Helper Widget: Card Statistik
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    Widget icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                icon,
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Baris Informasi
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isPriority,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isPriority
                ? Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? priorityLightIcons[habit.priority]
                          : priorityDarkIcons[habit.priority],
                    ),
                  )
                : Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              value,
              style: isPriority
                  ? Theme.of(context).textTheme.bodySmall
                  : Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
