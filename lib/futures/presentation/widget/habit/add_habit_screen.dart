import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hebipom/core/utils/vectors.dart';
import '../../../../core/configs/themes/themes.dart';
import '../../../../core/services/notivication_service.dart';
import '../../../domain/entity/habit.dart';
import '../../cubit/habit_cubit.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController spiritQuoteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();

  String selectedFrequency = 'daily';
  final List<String> frequencies = ['daily', 'thirdlyPerWeek', 'weekly'];

  String selectedCategory = 'other';

  String selectedPriority = '1';

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
    spiritQuoteController.dispose();
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
      setState(() => selectedTime = picked);
    }
  }

  Widget _buildPrioritySquare(String label, String value, Color color) {
    bool isSelected = selectedPriority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedPriority = value),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: isSelected ? 2 : 1),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: isSelected ? 14 : 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : color,
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
          'A D D  H A B I T',
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
            onPressed: () {
              _saveHabit();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Habit added successfully!'),
                  backgroundColor: Colors.green.shade500,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.check, color: Colors.green),
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
              const Text(
                "HABIT NAME",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'e.g., Morning Exercise',
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter habit name'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text(
                "SPIRIT QUOTE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: spiritQuoteController,
                autofocus: true,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'e.g., "I will have a body that is strong and healthy."',
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter spirit quote'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text(
                "REMINDER & FREQUENCY",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Reminder',
                          prefixIcon: Icon(Icons.access_time_filled, size: 20),
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
                      items: frequencies.map((String frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Text(
                            frequency.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,

                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) =>
                          setState(() => selectedFrequency = newValue!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "CATEGORY",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
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

                  // TAMBAHKAN TOOLTIP DI SINI
                  return Tooltip(
                    message: key
                        .toUpperCase(), // Teks yang muncul saat hover (desktop/web) atau long press (mobile)
                    decoration: BoxDecoration(
                      color: ThemeHabit.primaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = key;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(
                          12,
                        ), // Mengatur ukuran ikon agar lebih kecil
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeHabit.primaryButtonColor
                              : Theme.of(context).colorScheme.onSurface,
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
                          // ignore: deprecated_member_use
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "PRIORITY",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Row(
                    children: [
                      _buildPrioritySquare(
                        'DO',
                        '1',
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeHabit.habitCompnentLightVariant1
                            : ThemeHabit.habitCompnentDarkVariant1,
                      ),
                      const SizedBox(width: 16),
                      _buildPrioritySquare(
                        'SCHEDULE',
                        '2',
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeHabit.habitCompnentLightVariant3
                            : ThemeHabit.habitCompnentDarkVariant3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildPrioritySquare(
                        'DELEGATE',
                        '3',
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeHabit.habitCompnentLightVariant2
                            : ThemeHabit.habitCompnentDarkVariant2,
                      ),
                      const SizedBox(width: 16),
                      _buildPrioritySquare(
                        'ELIMINATE',
                        '4',
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeHabit.habitCompnentLightVariant4
                            : ThemeHabit.habitCompnentDarkVariant4,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: nameController.text.trim().hashCode.abs(),
        name: nameController.text.trim(),
        spiritQuote: spiritQuoteController.text.trim(),
        timeReminder: selectedTime,
        streak: 0,
        habitFrequency: selectedFrequency,
        category: selectedCategory,
        priority: selectedPriority,
        isCompleted: false,
        lastCompletedDate: null,
        completedDates: [],
      );

      // Cek mounted sebelum mengakses context
      if (!mounted) return;

      final cubit = context.read<HabitCubit>();
      final notifService = RepositoryProvider.of<NotificationService>(
        context,
        listen: false,
      );

      try {
        // Tunggu semua async operation selesai
        await cubit.createHabit(newHabit);
        await notifService.scheduleNotification(
          id: newHabit.id,
          title: 'Habit Reminder: ${newHabit.name.toUpperCase()}',
          body: newHabit.spiritQuote ?? 'Time to work on your habit!',
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        );

        await notifService.scheduleStreakAlert(newHabit);

        // Cek mounted lagi setelah async
        if (!mounted) return;

        // Pop dulu, baru show snackbar
        Navigator.pop(context);

        // Show snackbar di parent context (bukan context yang sudah di-pop)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Habit "${newHabit.name}" added successfully!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            backgroundColor: Colors.green.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
