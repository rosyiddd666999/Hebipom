import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/core/configs/themes/themes.dart';
import 'package:hebipom/core/widgets/my_button.dart';
import 'package:hebipom/futures/presentation/widget/habit/edit_habit_page.dart';
import 'package:intl/intl.dart';
import 'package:hebipom/futures/presentation/cubit/habit_cubit.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/utils/vectors.dart';
import '../../../domain/entity/habit.dart';

class HabitDetailPage extends StatefulWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  State<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  final Map<String, String> categories = {
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

  String _selectedPeriod = 'week';

  String _calculateCompletionRate(Habit habit) {
    if (habit.completedDates.isEmpty) {
      return "0%";
    }

    final sortedDates = [...habit.completedDates]..sort();
    final firstDate = sortedDates.first;
    final now = DateTime.now();

    final totalDays = now.difference(firstDate).inDays + 1;

    if (totalDays <= 0) return "0%";

    final rate = (habit.completedDates.length / totalDays) * 100;

    return "${rate.toStringAsFixed(1)}%";
  }

  List<FlSpot> _generateChartData(Habit habit) {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    if (_selectedPeriod == 'week') {
      for (int i = 6; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);

        final completedUntilDate = habit.completedDates
            .where((d) => d.isBefore(date.add(const Duration(days: 1))))
            .length;

        final daysSinceStart = habit.completedDates.isEmpty
            ? 1
            : date.difference(habit.completedDates.first).inDays + 1;

        final rate = daysSinceStart > 0
            ? (completedUntilDate / daysSinceStart) * 100
            : 0.0;

        spots.add(FlSpot((6 - i).toDouble(), rate));
      }
    } else {
      // 30 hari terakhir
      for (int i = 29; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);

        final completedUntilDate = habit.completedDates
            .where((d) => d.isBefore(date.add(const Duration(days: 1))))
            .length;

        final daysSinceStart = habit.completedDates.isEmpty
            ? 1
            : date.difference(habit.completedDates.first).inDays + 1;

        final rate = daysSinceStart > 0
            ? (completedUntilDate / daysSinceStart) * 100
            : 0.0;

        // X-axis: 0-29 merepresentasikan 30 hari
        spots.add(FlSpot((29 - i).toDouble(), rate));
      }
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<HabitCubit, List<Habit>>(
      builder: (context, habits) {
        final currentHabit = habits.firstWhere(
          (h) => h.id == widget.habit.id,
          orElse: () => widget.habit,
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
                    builder: (context) => EditHabitPage(habit: widget.habit),
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
                    categories[currentHabit.category]!,
                    height: 80,
                    color: Theme.of(context).brightness == Brightness.light
                        ? priorityLightIcons[currentHabit.priority]
                        : priorityDarkIcons[currentHabit.priority],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '"${currentHabit.spiritQuote}"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),

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

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
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
                              currentHabit,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.access_time_rounded,
                              "Waktu Reminder",
                              currentHabit.timeReminder.format(context),
                              false,
                              currentHabit,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.calendar_today_rounded,
                              "Frekuensi",
                              currentHabit.habitFrequency.toUpperCase(),
                              false,
                              currentHabit,
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
                              currentHabit,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        "STATISTICS",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildPeriodButton(
                                    context,
                                    'Mingguan',
                                    'week',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildPeriodButton(
                                    context,
                                    'Bulanan',
                                    'month',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            Text(
                              "Completion Rate Trend",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),

                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 25,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: colorScheme.outlineVariant
                                            .withOpacity(0.3),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          if (_selectedPeriod == 'week') {
                                            final days = [
                                              'S',
                                              'M',
                                              'T',
                                              'W',
                                              'T',
                                              'F',
                                              'S',
                                            ];
                                            if (value.toInt() >= 0 &&
                                                value.toInt() < days.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Text(
                                                  days[value.toInt()],
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              );
                                            }
                                          } else {
                                            final labels = [
                                              'D1',
                                              'D6',
                                              'D11',
                                              'D16',
                                              'D21',
                                              'D26',
                                            ];
                                            if (value.toInt() >= 0 &&
                                                value.toInt() < labels.length) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Text(
                                                  labels[value.toInt()],
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              );
                                            }
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: 25,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}%',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                      color: colorScheme.outlineVariant
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  minX: 0,
                                  maxX: _selectedPeriod == 'week' ? 6 : 5,
                                  minY: 0,
                                  maxY: 100,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _generateChartData(currentHabit),
                                      isCurved: true,
                                      color: colorScheme.primary,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) {
                                              return FlDotCirclePainter(
                                                radius: 4,
                                                color: colorScheme.primary,
                                                strokeWidth: 2,
                                                strokeColor:
                                                    colorScheme.surface,
                                              );
                                            },
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: colorScheme.primary.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Divider(height: 30),

                            _buildInfoRow(
                              context,
                              Icons.check_circle_outline_rounded,
                              "Total Hari Completed",
                              "${currentHabit.streak} hari",
                              false,
                              currentHabit,
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              context,
                              Icons.trending_up_rounded,
                              "Completion Rate",
                              _calculateCompletionRate(currentHabit),
                              false,
                              currentHabit,
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
          floatingActionButton: currentHabit.isCompleted
              ? MyButton(
                  onPressed: () {
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

  Widget _buildPeriodButton(BuildContext context, String label, String value) {
    final isSelected = _selectedPeriod == value;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

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
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
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

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isPriority,
    Habit habit,
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
