import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/utils/vectors.dart';
import '../../../../domain/entity/habit.dart';
import '../../../../domain/entity/pomodoro.dart';
import '../../../cubit/habit_cubit.dart';
import '../../../cubit/pomodoro_cubit.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitCubit, List<Habit>>(
      builder: (context, habits) {
        return BlocBuilder<PomodoroCubit, List<Pomodoro>>(
          builder: (context, pomodoros) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'STATISTICS',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    onPressed: _isSharing
                        ? null
                        : () => _captureAndShare(habits, pomodoros),
                  ),
                ],
              ),
              body: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCards(context, habits, pomodoros),

                      const SizedBox(height: 24),

                      _buildSectionTitle(context, 'WEEKLY TREND'),
                      const SizedBox(height: 16),
                      _buildWeeklyTrendChart(context, habits, pomodoros),

                      const SizedBox(height: 24),

                      _buildSectionTitle(context, 'CATEGORY DISTRIBUTION'),
                      const SizedBox(height: 16),
                      _buildCategoryDistribution(context, habits),

                      const SizedBox(height: 24),

                      _buildSectionTitle(context, 'PRODUCTIVITY INSIGHTS'),
                      const SizedBox(height: 16),
                      _buildProductivityInsights(context, habits, pomodoros),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _captureAndShare(
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) async {
    setState(() => _isSharing = true);

    try {
      final Uint8List imageBytes = await _screenshotController
          .captureFromWidget(
            _buildSharePoster(context, habits, pomodoros),
            context: context,
            delay: const Duration(milliseconds: 100),
          );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/productivity_summary.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Lihat progres produktivitas saya hari ini! 🚀 #HabitTracker');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membagikan: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Widget _buildSharePoster(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    return Container(
      width: 375,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'MY PRODUCTIVITY',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          _buildOverviewShareCards(context, habits, pomodoros),
          const SizedBox(height: 20),

          Text(
            'INSIGHTS',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildProductivityShareInsights(context, habits, pomodoros),

          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo_light.png',
                  width: 25,
                  height: 25,
                ),
                const SizedBox(height: 8),
                Text(
                  'Generated by Hebipom App',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildOverviewCards(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    final totalHabits = habits.length;
    final completedToday = habits.where((h) => h.isCompleted).length;
    final totalFocusHours = _calculateTotalFocusHours(pomodoros);
    final longestStreak = _calculateLongestConsecutiveStreak(habits);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                'Total Habits',
                totalHabits.toString(),
                SvgPicture.asset(
                  AppVectors.habitLight,
                  width: 24,
                  height: 24,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                context,
                'Completed Today',
                '${completedToday.toString()}/${totalHabits.toString()}',
                const Icon(Icons.check, size: 24, color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                'Focus Hours',
                totalFocusHours,
                SvgPicture.asset(
                  AppVectors.pomodoroLight,
                  width: 24,
                  height: 24,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                context,
                'Longest Streak',
                '$longestStreak days',
                SvgPicture.asset(AppVectors.flameActive, width: 24, height: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewShareCards(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    final totalHabits = habits.length;
    final completedToday = habits.where((h) => h.isCompleted).length;
    final totalFocusHours = _calculateTotalFocusHours(pomodoros);
    final longestStreak = _calculateLongestConsecutiveStreak(habits);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOverviewShareCard(
                context,
                'Total Habits',
                totalHabits.toString(),
                SvgPicture.asset(
                  AppVectors.habitLight,
                  width: 24,
                  height: 24,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewShareCard(
                context,
                'Completed Today',
                '${completedToday.toString()}/${totalHabits.toString()}',
                const Icon(Icons.check, size: 24, color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewShareCard(
                context,
                'Focus Hours',
                totalFocusHours,
                SvgPicture.asset(
                  AppVectors.pomodoroLight,
                  width: 24,
                  height: 24,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewShareCard(
                context,
                'Longest Streak',
                '$longestStreak days',
                SvgPicture.asset(AppVectors.flameActive, width: 24, height: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String value,
    Widget icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              icon,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewShareCard(
    BuildContext context,
    String title,
    String value,
    Widget icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              icon,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendChart(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final habitData = _getWeeklyHabitData(habits);
    final pomodoroData = _getWeeklyPomodoroData(pomodoros);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habits & Pomodoro Sessions',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outlineVariant.withOpacity(0.3),
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
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: _getMaxYValue(habitData, pomodoroData),
                lineBarsData: [
                  LineChartBarData(
                    spots: habitData,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.green,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),

                  LineChartBarData(
                    spots: pomodoroData,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.orange,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(context, Colors.green, 'Habits'),
              const SizedBox(width: 24),
              _buildLegend(context, Colors.orange, 'Pomodoro'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildCategoryDistribution(BuildContext context, List<Habit> habits) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryData = _getCategoryData(habits);

    if (categoryData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            'No habits data available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: categoryData.entries.map((entry) {
                        final color = _getCategoryColor(entry.key);
                        final percentage = (entry.value / habits.length * 100)
                            .toStringAsFixed(1);
                        return PieChartSectionData(
                          color: color,
                          value: entry.value.toDouble(),
                          title: '$percentage%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryData.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.key} (${entry.value})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityInsights(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgStreak = _calculateAverageStreak(habits);
    final completionRate = _calculateOverallCompletionRate(habits);
    final totalSessions = _calculateTotalSessions(pomodoros);
    final avgSessionsPerDay = _calculateAvgSessionsPerDay(pomodoros);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _buildInsightRow(
            context,
            Icons.trending_up,
            'Average Streak',
            '$avgStreak days',
          ),
          const Divider(height: 24),
          _buildInsightRow(
            context,
            Icons.percent,
            'Completion Rate',
            completionRate,
          ),
          const Divider(height: 24),
          _buildInsightRow(
            context,
            Icons.play_circle_outline,
            'Total Sessions',
            totalSessions.toString(),
          ),
          const Divider(height: 24),
          _buildInsightRow(
            context,
            Icons.today_outlined,
            'Avg Sessions/Day',
            avgSessionsPerDay,
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityShareInsights(
    BuildContext context,
    List<Habit> habits,
    List<Pomodoro> pomodoros,
  ) {
    final avgStreak = _calculateAverageStreak(habits);
    final completionRate = _calculateOverallCompletionRate(habits);
    final totalSessions = _calculateTotalSessions(pomodoros);
    final avgSessionsPerDay = _calculateAvgSessionsPerDay(pomodoros);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInsightShareRow(
            context,
            Icons.trending_up,
            'Average Streak',
            '$avgStreak days',
          ),
          const Divider(height: 24),
          _buildInsightShareRow(
            context,
            Icons.percent,
            'Completion Rate',
            completionRate,
          ),
          const Divider(height: 24),
          _buildInsightShareRow(
            context,
            Icons.play_circle_outline,
            'Total Sessions',
            totalSessions.toString(),
          ),
          const Divider(height: 24),
          _buildInsightShareRow(
            context,
            Icons.today_outlined,
            'Avg Sessions/Day',
            avgSessionsPerDay,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
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
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInsightShareRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _calculateTotalFocusHours(List<Pomodoro> pomodoros) {
    if (pomodoros.isEmpty) return '0h';

    final totalMinutes = pomodoros.fold<int>(
      0,
      (sum, p) => sum + (p.completedCycles * p.timePomodoro),
    );

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  int _calculateLongestConsecutiveStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;

    final allDates = <DateTime>{};
    for (var habit in habits) {
      for (var date in habit.completedDates) {
        allDates.add(DateTime(date.year, date.month, date.day));
      }
    }

    if (allDates.isEmpty) return 0;

    final sortedDates = allDates.toList()..sort();

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? previousDate;

    for (var date in sortedDates) {
      final allHabitsCompleted = habits.every(
        (habit) => habit.isCompletedOnDate(date),
      );

      if (!allHabitsCompleted) {
        currentStreak = 0;
        previousDate = null;
        continue;
      }

      if (previousDate == null) {
        currentStreak = 1;
      } else {
        final difference = date.difference(previousDate).inDays;
        if (difference == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }

      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      previousDate = date;
    }

    return longestStreak;
  }

  List<FlSpot> _getWeeklyHabitData(List<Habit> habits) {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final count = habits.where((h) => h.isCompletedOnDate(date)).length;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  List<FlSpot> _getWeeklyPomodoroData(List<Pomodoro> pomodoros) {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final count = pomodoros
          .where((p) {
            if (p.createdAt == null) return false;
            final pDate = p.createdAt!;
            return pDate.year == date.year &&
                pDate.month == date.month &&
                pDate.day == date.day;
          })
          .fold<int>(0, (sum, p) => sum + p.completedCycles);
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }

    return spots;
  }

  double _getMaxYValue(List<FlSpot> habitData, List<FlSpot> pomodoroData) {
    final maxHabit = habitData.isEmpty
        ? 0.0
        : habitData.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final maxPomodoro = pomodoroData.isEmpty
        ? 0.0
        : pomodoroData.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final max = maxHabit > maxPomodoro ? maxHabit : maxPomodoro;
    return (max + 5).ceilToDouble();
  }

  Map<String, int> _getCategoryData(List<Habit> habits) {
    final categoryCount = <String, int>{};
    for (var habit in habits) {
      categoryCount[habit.category] = (categoryCount[habit.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'study': Colors.blue,
      'work': Colors.purple,
      'exercise': Colors.green,
      'health': Colors.red,
      'sleep': Colors.indigo,
      'read': Colors.orange,
      'write': Colors.teal,
      'drink': Colors.cyan,
      'saving': Colors.amber,
      'other': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }

  double _calculateAverageStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    final totalStreak = habits.fold<int>(0, (sum, h) => sum + h.streak);
    return totalStreak / habits.length;
  }

  String _calculateOverallCompletionRate(List<Habit> habits) {
    if (habits.isEmpty) return '0%';

    int totalPossibleDays = 0;
    int totalCompletedDays = 0;

    for (var habit in habits) {
      if (habit.completedDates.isEmpty) continue;

      final sortedDates = [...habit.completedDates]..sort();
      final firstDate = sortedDates.first;
      final now = DateTime.now();
      final daysSinceStart = now.difference(firstDate).inDays + 1;

      totalPossibleDays += daysSinceStart;
      totalCompletedDays += habit.completedDates.length;
    }

    if (totalPossibleDays == 0) return '0%';

    final rate = (totalCompletedDays / totalPossibleDays * 100);
    return '${rate.toStringAsFixed(1)}%';
  }

  int _calculateTotalSessions(List<Pomodoro> pomodoros) {
    return pomodoros.fold<int>(0, (sum, p) => sum + p.completedCycles);
  }

  String _calculateAvgSessionsPerDay(List<Pomodoro> pomodoros) {
    if (pomodoros.isEmpty) return '0';

    final pomodorosWithDate = pomodoros
        .where((p) => p.createdAt != null)
        .toList();
    if (pomodorosWithDate.isEmpty) return '0';

    final sortedDates = pomodorosWithDate.map((p) => p.createdAt!).toList()
      ..sort();
    final firstDate = sortedDates.first;
    final now = DateTime.now();
    final daysSinceStart = now.difference(firstDate).inDays + 1;

    final totalSessions = _calculateTotalSessions(pomodoros);
    final avg = totalSessions / daysSinceStart;

    return avg.toStringAsFixed(1);
  }
}
