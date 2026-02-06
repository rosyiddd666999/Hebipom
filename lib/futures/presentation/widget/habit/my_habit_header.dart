import 'package:flutter/material.dart';
import '../pomodoro/mini_pomodoro_player.dart';
import 'add_habit_screen.dart';

class MyHabitHeader extends StatelessWidget {
  const MyHabitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // String currentMonthName = DateFormat('MMM', 'id_ID').format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () async {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        Row(
          children: [
            const MiniPomodoroPlayer(),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AddHabitPage();
                  },
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white,),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
