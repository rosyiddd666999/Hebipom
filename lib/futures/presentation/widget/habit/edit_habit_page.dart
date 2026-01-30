// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/configs/themes/themes.dart';
import '../../../../core/services/notivication_service.dart';
import '../../../../core/utils/vectors.dart';
import '../../../domain/entity/habit.dart';
import '../../cubit/habit_cubit.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({super.key, required this.habit});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController spiritQuoteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late TimeOfDay selectedTime;
  late String selectedFrequency;
  late String selectedCategory;
  late String selectedPriority;
  late bool isCompleted;

  late String initialName;
  late String initialQuote;
  late TimeOfDay initialTime;
  late String initialFrequency;
  late String initialCategory;
  late String initialPriority;
  late bool initialIsCompleted;

  bool _hasChanges = false;

  final List<String> frequencies = ['daily', 'thirdlyPerWeek', 'weekly'];

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
  void initState() {
    super.initState();
    // Inisialisasi Data dari widget.habit
    nameController.text = widget.habit.name;
    spiritQuoteController.text = widget.habit.spiritQuote!;
    selectedTime = widget.habit.timeReminder;
    selectedFrequency = widget.habit.habitFrequency;
    selectedCategory = widget.habit.category;
    selectedPriority = widget.habit.priority;
    isCompleted = widget.habit.isCompleted;

    // Simpan nilai awal untuk komparasi perubahan
    initialName = widget.habit.name;
    initialQuote = widget.habit.spiritQuote!;
    initialTime = widget.habit.timeReminder;
    initialFrequency = widget.habit.habitFrequency;
    initialCategory = widget.habit.category;
    initialPriority = widget.habit.priority;
    initialIsCompleted = widget.habit.isCompleted;

    nameController.addListener(_checkForChanges);
    spiritQuoteController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final bool changed =
        nameController.text.trim() != initialName ||
        spiritQuoteController.text.trim() != initialQuote ||
        selectedTime != initialTime ||
        selectedFrequency != initialFrequency ||
        selectedCategory != initialCategory ||
        selectedPriority != initialPriority ||
        isCompleted != initialIsCompleted;

    if (_hasChanges != changed) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    spiritQuoteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
      _checkForChanges();
    }
  }

  Widget _buildPrioritySquare(String label, String value, Color color) {
    bool isSelected = selectedPriority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedPriority = value);
          _checkForChanges();
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: isSelected ? 2 : 1),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E D I T  H A B I T',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _hasChanges ? () => _onSavePressed(context) : null,
            icon: Icon(
              Icons.check,
              color: _hasChanges ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("HABIT NAME"),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Morning Exercise',
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("SPIRIT QUOTE"),
              TextFormField(
                controller: spiritQuoteController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Your motivation...',
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("REMINDER & FREQUENCY"),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          prefixIcon: Icon(Icons.access_time_filled, size: 20),
                        ),
                        child: Text(
                          selectedTime.format(context),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        prefixIcon: Icon(Icons.repeat, size: 20),
                      ),
                      items: frequencies
                          .map(
                            (f) => DropdownMenuItem(
                              value: f,
                              child: Text(
                                f.toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedFrequency = val!);
                        _checkForChanges();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("CATEGORY"),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: lightCategories.length,
                itemBuilder: (context, index) {
                  String key = lightCategories.keys.elementAt(index);
                  String assetPath =
                      Theme.of(context).brightness == Brightness.light
                      ? darkCategories[key]!
                      : lightCategories[key]!;
                  bool isSelected = selectedCategory == key;

                  return Tooltip(
                    message: key.toUpperCase(),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = key);
                        _checkForChanges();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeHabit.primaryButtonColor
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? ThemeHabit.primaryButtonColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: SvgPicture.asset(
                          assetPath,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("PRIORITY"),
              Row(
                children: [
                  _buildPrioritySquare(
                    'DO',
                    '1',
                    ThemeHabit.habitCompnentDarkVariant1,
                  ),
                  const SizedBox(width: 12),
                  _buildPrioritySquare(
                    'SCHEDULE',
                    '2',
                    ThemeHabit.habitCompnentDarkVariant3,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPrioritySquare(
                    'DELEGATE',
                    '3',
                    ThemeHabit.habitCompnentDarkVariant2,
                  ),
                  const SizedBox(width: 12),
                  _buildPrioritySquare(
                    'ELIMINATE',
                    '4',
                    ThemeHabit.habitCompnentDarkVariant4,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Status Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text(
                      "MARK AS COMPLETED",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isCompleted,
                      onChanged: (val) {
                        setState(() => isCompleted = val);
                        _checkForChanges();
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Delete Button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showDeleteDialog(),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    "DELETE HABIT",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  void _onSavePressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedHabit = widget.habit.copyWith(
        name: nameController.text.trim(),
        spiritQuote: spiritQuoteController.text.trim(),
        timeReminder: selectedTime,
        habitFrequency: selectedFrequency,
        category: selectedCategory,
        priority: selectedPriority,
        isCompleted: isCompleted,
      );

      await context.read<HabitCubit>().updateHabit(updatedHabit);

      // Handle logic completion status
      if (isCompleted != initialIsCompleted) {
        if (isCompleted) {
          context.read<HabitCubit>().markHabitAsCompleted(widget.habit.id);
        } else {
          context.read<HabitCubit>().markHabitAsNotCompleted(widget.habit.id);
        }
      }

      final notifService = RepositoryProvider.of<NotificationService>(
        context,
        listen: false,
      );
      await notifService.scheduleNotification(
        id: updatedHabit.id,
        title: 'Reminder: ${updatedHabit.name}',
        body: 'Time for your habit!',
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Habit updated!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitCubit>().deleteHabit(widget.habit.id);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
