import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hebipom/core/configs/themes/themes.dart';
import '../../../../core/services/notivication_service.dart';
import '../../../../core/utils/vectors.dart';
import '../../../domain/entity/habit.dart';
import '../../cubit/habit_cubit.dart';

class HabitItem extends StatelessWidget {
  HabitItem({super.key, required this.habit});

  final Habit habit;

  final Map<String, String> habitCategories = {
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

  final Map<String, Color> priorityLightColors = {
    '1': ThemeHabit.habitCompnentLightVariant1,
    '2': ThemeHabit.habitCompnentLightVariant3,
    '3': ThemeHabit.habitCompnentLightVariant2,
    '4': ThemeHabit.habitCompnentLightVariant4,
  };

  final Map<String, Color> priorityDarkColors = {
    '1': ThemeHabit.habitCompnentDarkVariant1,
    '2': ThemeHabit.habitCompnentDarkVariant3,
    '3': ThemeHabit.habitCompnentDarkVariant2,
    '4': ThemeHabit.habitCompnentDarkVariant4,
  };

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          habit.isCompleted
              ? SlidableAction(
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: Colors.red,
                  icon: Icons.cancel,
                  onPressed: (context) {
                    context.read<HabitCubit>().markHabitAsNotCompleted(
                      habit.id,
                    );
                    context.read<NotificationService>().scheduleNotification(
                      id: habit.id,
                      title: 'Habit Reminder: ${habit.name.toUpperCase()}',
                      body: habit.spiritQuote ?? 'Time to work on your habit!',
                      hour: habit.timeReminder.hour,
                      minute: habit.timeReminder.minute,
                    );

                    context.read<NotificationService>().scheduleStreakAlert(habit);
                  },
                )
              : SlidableAction(
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: Colors.green,
                  icon: Icons.done,
                  onPressed: (context) async {
                    context.read<HabitCubit>().markHabitAsCompleted(habit.id);
                  },
                ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? priorityLightColors[habit.priority]
                    : priorityDarkColors[habit.priority],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                habitCategories[habit.category] ?? habitCategories['other']!,
                width: 24,
                height: 24,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        size: 12,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${habit.timeReminder.hour}:${habit.timeReminder.minute.toString().padLeft(2, '0')} ${habit.timeReminder.hour < 12 ? 'AM' : 'PM'}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                SvgPicture.asset(
                  habit.isCompleted
                      ? 'assets/vectors/flame_active.svg'
                      : 'assets/vectors/flame_nonactive.svg',
                  width: 24,
                  height: 24,
                ),
                Text(
                  habit.streak.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
