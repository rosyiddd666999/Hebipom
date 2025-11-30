import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hebipom/futures/core/utils/vectors.dart';
import 'package:hebipom/futures/core/widgets/my_button.dart';
import '../../../core/services/notivication_service.dart';
import '../../domain/entity/habit.dart';
import '../cubit/habit_cubit.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();

  String selectedFrequency = 'daily';
  final List<String> frequencies = ['daily', 'thirdlyPerWeek', 'weekly'];

  String selectedCategory = 'other';
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
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,

      initialTime: selectedTime,

      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),

          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
            'A D D  H A B I T',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Morning Exercise',
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter habit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectTime(context),

                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Time Reminder',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Habit Frequency',
                  prefixIcon: Icon(Icons.repeat),
                ),
                items: frequencies.map((String frequency) {
                  return DropdownMenuItem<String>(
                    value: frequency,
                    child: Text(
                      frequency.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedFrequency = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Habit Category'),
                items: Theme.of(context).brightness == Brightness.light
                    ? darkCategories.keys.map((String frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                darkCategories[frequency]!,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                frequency.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : lightCategories.keys.map((String frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                lightCategories[frequency]!,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                frequency.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        MyButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newHabit = Habit(
                id: nameController.text.trim().hashCode.abs(),
                name: nameController.text.trim(),
                timeReminder: selectedTime,
                streak: 0,
                habitFrequency: selectedFrequency,
                category: selectedCategory,
                isCompleted: false,
                lastCompletedDate: null,
              );
              await context.read<HabitCubit>().createHabit(newHabit);
              final notifService = RepositoryProvider.of<NotificationService>(
                // ignore: use_build_context_synchronously
                context,
                listen: false,
              );
              await notifService.scheduleNotification(
                id: newHabit.id,
                title: 'Habit Reminder: ${newHabit.name}',
                body: 'Time to complete your habit!',
                hour: selectedTime.hour,
                minute: selectedTime.minute,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Habit "${newHabit.name}" added successfully!',
                    ),
                    backgroundColor: Colors.green.shade800,
                  ),
                );
                Navigator.pop(context);
              }
            }
          },
          label: 'add',
        ),
      ],
    );
  }
}
