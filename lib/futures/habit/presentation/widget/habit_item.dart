import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/vectors.dart';
import '../../domain/entity/habit.dart';
import '../cubit/habit_cubit.dart';

class HabitItem extends StatelessWidget {
  HabitItem({super.key, required this.habit});

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
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Theme.of(context).brightness == Brightness.light
                  ? darkCategories[habit.category] ?? darkCategories['other']!
                  : lightCategories[habit.category] ??
                        lightCategories['other']!,
              width: 35,
              height: 35,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                habit.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                SvgPicture.asset(
                  habit.isCompleted
                      ? 'assets/vectors/flame_active.svg'
                      : 'assets/vectors/flame_nonactive.svg',
                  width: 35,
                  height: 35,
                ),
                Text(
                  habit.streak.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
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
