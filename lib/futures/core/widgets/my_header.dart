import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../habit/presentation/widget/add_habit_dialog.dart';

class MyHeader extends StatelessWidget {
  final VoidCallback? onTapDrawer;
  const MyHeader({super.key, this.onTapDrawer});

  @override
  Widget build(BuildContext context) {
    String currentMonthName = DateFormat('MMM', 'id_ID').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTapDrawer,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.menu),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "${DateTime.now().day} $currentMonthName ${DateTime.now().year}"
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 5,
                ),
              ),
            ],
          ),

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AddHabitDialog();
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
