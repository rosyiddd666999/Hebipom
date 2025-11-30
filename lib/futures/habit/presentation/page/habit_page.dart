import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hebipom/futures/core/widgets/my_header.dart';
import '../../domain/entity/habit.dart';
import '../cubit/habit_cubit.dart';
import '../widget/habit_detail_dialog.dart';
import '../widget/habit_item.dart';
import '../../../core/widgets/my_sidebar.dart';

class HabitPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MySidebar(),
      body: ListView(
        children: [
          MyHeader(onTapDrawer: () => _scaffoldKey.currentState!.openDrawer(),),
          BlocBuilder<HabitCubit, List<Habit>>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List.generate(state.length, (index) {
                      final habit = state[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return HabitDetailDialog(habit: habit);
                                },
                              );
                            },
                            child: HabitItem(habit: habit),
                          ),

                          if (index < 9) const SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
