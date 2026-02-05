// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hebipom/futures/presentation/page/habit_detail/habit_detail_page.dart';
import 'package:hebipom/futures/presentation/widget/habit/my_habit_header.dart';
import 'package:intl/intl.dart';
import '../../../domain/entity/habit.dart';
import '../../cubit/habit_cubit.dart';
import '../../widget/habit/habit_item.dart';
import '../../../../core/widgets/my_sidebar.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  late DateTime _selectedDate;
  late DateTime _focusDate;
  final int _gridSize = 35;

  @override
  void initState() {
    super.initState();
    // Inisiasi langsung ke tanggal hari ini
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _focusDate = DateTime(now.year, now.month, 1);
  }

  // --- LOGIKA UTAMA (Color Logic) ---
  Color _getColorForDate(DateTime date, List<Habit> activeHabits) {
    if (activeHabits.isEmpty) {
      return Theme.of(context).colorScheme.secondary;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    final targetDate = DateUtils.dateOnly(date);

    int completedCount = 0;

    for (var habit in activeHabits) {
      // Cek apakah habit completed pada tanggal target
      bool isValidCompleted = false;

      // Jika tanggal target adalah hari ini
      if (targetDate.isAtSameMomentAs(today)) {
        // Hanya hitung jika habit masih isCompleted = true hari ini
        if (habit.isCompleted && habit.lastCompletedDate != null) {
          final lastCompletedDay = DateUtils.dateOnly(habit.lastCompletedDate!);
          if (lastCompletedDay.isAtSameMomentAs(today)) {
            isValidCompleted = true;
          }
        }
      }
      // Jika tanggal target adalah hari lalu atau sebelumnya
      else {
        // Cek di completedDates history
        isValidCompleted = habit.isCompletedOnDate(targetDate);
      }

      if (isValidCompleted) {
        completedCount++;
      }
    }

    if (completedCount == 0) {
      return Theme.of(context).colorScheme.secondary;
    }

    final totalHabits = activeHabits.length;
    final double percentage = completedCount / totalHabits;
    final baseColor = Theme.of(context).colorScheme.primary;

    // Gradasi warna berdasarkan persentase penyelesaian
    if (percentage >= 1.0) return baseColor;
    if (percentage >= 0.75) return baseColor.withOpacity(0.8);
    if (percentage >= 0.50) return baseColor.withOpacity(0.5);
    if (percentage >= 0.25) return baseColor.withOpacity(0.3);
    return baseColor.withOpacity(0.1);
  }

  // --- NAVIGATION ---
  void _goToPreviousMonth() {
    setState(() {
      _focusDate = DateTime(_focusDate.year, _focusDate.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusDate = DateTime(_focusDate.year, _focusDate.month + 1, 1);
    });
  }

  // --- LOGIKA GRID KALENDER (5x7) ---
  List<DateTime> _generateDatesForMonth() {
    final firstDayOfMonth = DateTime(_focusDate.year, _focusDate.month, 1);

    int dayOfWeek = firstDayOfMonth.weekday; // 1 (Senin) - 7 (Minggu)
    int daysToSubtract = (dayOfWeek == DateTime.sunday) ? 0 : dayOfWeek;

    DateTime startDay = firstDayOfMonth.subtract(
      Duration(days: daysToSubtract),
    );

    List<DateTime> dates = [];
    for (int i = 0; i < _gridSize; i++) {
      dates.add(startDay.add(Duration(days: i)));
    }
    return dates;
  }

  void _showHabitDetailDialog(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => HabitDetailPage(habit: habit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MySidebar(),
        body: BlocBuilder<HabitCubit, List<Habit>>(
          builder: (context, activeHabits) {
            final dates = _generateDatesForMonth();

            final today = DateUtils.dateOnly(DateTime.now());
            final selectedDateOnly = DateUtils.dateOnly(_selectedDate);

            List<Habit> displayedHabits;

            if (selectedDateOnly.isAtSameMomentAs(today)) {
              // Jika hari ini, tampilkan semua habit aktif
              displayedHabits = activeHabits;
            } else {
              // Jika bukan hari ini, tampilkan habit yang completed pada tanggal tersebut
              displayedHabits = activeHabits.where((h) {
                return h.isCompletedOnDate(_selectedDate);
              }).toList();
            }

            // Hitung completed habits untuk display
            int completedCount = displayedHabits.where((h) {
              if (selectedDateOnly.isAtSameMomentAs(today)) {
                return h.isCompleted;
              } else {
                return h.isCompletedOnDate(_selectedDate);
              }
            }).length;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 10),
                    _buildMonthNavigation(),
                    const SizedBox(height: 16),
                    _buildDayLabels(context),
                    const SizedBox(height: 16),
                    _buildContributionGrid(dates, activeHabits),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HABITS',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Completed : $completedCount / ${displayedHabits.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment:
                          activeHabits.isEmpty &&
                              selectedDateOnly.isAtSameMomentAs(today)
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        if (activeHabits.isEmpty &&
                            selectedDateOnly.isAtSameMomentAs(today))
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: _buildEmptyState(
                              "Belum ada habit aktif.\nKlik tombol '+' di kanan atas\nuntuk menambahkan.",
                            ),
                          )
                        else if (displayedHabits.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: _buildEmptyState(
                              "Tidak ada aktivitas pada tanggal ini.",
                            ),
                          )
                        else
                          ...displayedHabits.map(
                            (habit) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => _showHabitDetailDialog(habit),
                                child: HabitItem(habit: habit),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const MyHabitHeader();
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 16),
          onPressed: _goToPreviousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy').format(_focusDate).toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _goToNextMonth,
        ),
      ],
    );
  }

  Widget _buildDayLabels(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
          .map(
            (day) => Text(
              day,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
          .toList(),
    );
  }

  Widget _buildContributionGrid(
    List<DateTime> dates,
    List<Habit> activeHabits,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemCount: _gridSize,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isCurrentMonth = date.month == _focusDate.month;
          final isSelected =
              date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          if (!isCurrentMonth) {
            return const SizedBox();
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Tooltip(
              message: DateFormat('EEEE, d MMM yyyy').format(date),
              child: Container(
                decoration: BoxDecoration(
                  color: _getColorForDate(date, activeHabits),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
