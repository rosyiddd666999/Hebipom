// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/services/notivication_service.dart';
import '../../../core/utils/vectors.dart';
import '../../domain/entity/habit.dart';
import '../cubit/habit_cubit.dart';

class HabitDetailDialog extends StatefulWidget {
  final Habit habit;

  const HabitDetailDialog({super.key, required this.habit});

  @override
  State<HabitDetailDialog> createState() => _HabitDetailDialogState();
}

class _HabitDetailDialogState extends State<HabitDetailDialog> {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late TimeOfDay selectedTime;
  late String selectedFrequency;
  late String selectedCategory;
  late bool isCompleted; // Dikembalikan sebagai state lokal

  late String initialName;
  late TimeOfDay initialTime;
  late String initialFrequency;
  late String initialCategory;
  late bool initialIsCompleted;

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

    nameController.text = widget.habit.name;
    selectedTime = widget.habit.timeReminder;
    selectedFrequency = widget.habit.habitFrequency;
    final validCategories = lightCategories.keys.toSet();
    selectedCategory = validCategories.contains(widget.habit.category)
        ? widget.habit.category
        : 'other';
    isCompleted = widget.habit.isCompleted; // Inisialisasi state lokal

    initialName = widget.habit.name;
    initialTime = widget.habit.timeReminder;
    initialFrequency = widget.habit.habitFrequency;
    initialCategory = selectedCategory;
    initialIsCompleted = widget.habit.isCompleted; // Simpan nilai awal

    nameController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    nameController.removeListener(_checkForChanges);
    nameController.dispose();
    super.dispose();
  }

  bool _hasChanges = false;

  // **Perbaikan:** Memasukkan isCompleted ke dalam pengecekan perubahan
  void _checkForChanges() {
    final currentName = nameController.text.trim();
    final currentTime = selectedTime;
    final currentFrequency = selectedFrequency;
    final currentCategory = selectedCategory;
    final currentIsCompleted = isCompleted; // Gunakan state lokal

    final nameChanged = currentName != initialName;
    final timeChanged = currentTime != initialTime;
    final frequencyChanged = currentFrequency != initialFrequency;
    final categoryChanged = currentCategory != initialCategory;
    final isCompletedChanged =
        currentIsCompleted !=
        initialIsCompleted; // Bandingkan dengan nilai awal

    final newHasChanges =
        nameChanged ||
        timeChanged ||
        frequencyChanged ||
        categoryChanged ||
        isCompletedChanged;

    if (_hasChanges != newHasChanges) {
      setState(() {
        _hasChanges = newHasChanges;
      });
    }
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
        _checkForChanges();
      });
    }
  }

  void _onFrequencyChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedFrequency = newValue;
        _checkForChanges();
      });
    }
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedCategory = newValue;
        _checkForChanges();
      });
    }
  }

  // **Perubahan:** Hanya mengubah state lokal dan memanggil _checkForChanges
  void _onSwitchChanged(bool? value) async {
    if (value != null) {
      setState(() {
        isCompleted = value; // Perbarui state lokal
        _checkForChanges(); // Perbarui status perubahan
      });
    }
  }

  void _onSavePressed(BuildContext context) async {
    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap melakukan perubahan terlebih dahulu.'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // 1. Eksekusi perubahan pada properti non-isCompleted
      final updatedHabit = widget.habit.copyWith(
        name: nameController.text.trim(),
        timeReminder: selectedTime,
        habitFrequency: selectedFrequency,
        category: selectedCategory,
      );

      // Kita harus memanggil updateHabit terlepas dari apakah ada perubahan non-isCompleted atau tidak,
      // karena updateHabit ini menangani semua perubahan non-isCompleted.
      // Jika yang berubah HANYA isCompleted, updateHabit akan menyimpan properti yang sama.
      await context.read<HabitCubit>().updateHabit(updatedHabit);

      // 2. Eksekusi perubahan isCompleted HANYA JIKA ADA PERUBAHAN
      if (isCompleted != initialIsCompleted) {
        if (isCompleted) {
          // Jika status baru adalah Completed
          context.read<HabitCubit>().markHabitAsCompleted(widget.habit.id);
        } else {
          // Jika status baru adalah Not Completed
          context.read<HabitCubit>().markHabitAsNotCompleted(widget.habit.id);
        }
        // Catatan: Pemanggilan Cubit ini mungkin akan memicu pembaruan UI (melalui BlocBuilder/Listener)
        // di widget induk yang berisi daftar habit.
      }

      // Logika notifikasi (tetap sama)
      final notifService = RepositoryProvider.of<NotificationService>(
        context,
        listen: false,
      );

      await notifService.scheduleNotification(
        id: updatedHabit.id,
        title: 'Habit Reminder: ${updatedHabit.name}',
        body: 'Time to complete your habit!',
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit "${updatedHabit.name}" berhasil diupdate!'),
            backgroundColor: Colors.green.shade800,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  List<DropdownMenuItem<String>> _buildCategoryItems(BuildContext context) {
    final categories = Theme.of(context).brightness == Brightness.light
        ? darkCategories
        : lightCategories;

    return categories.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Row(
          children: [
            SvgPicture.asset(entry.value, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              entry.key.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Color saveButtonColor = _hasChanges
        ? Colors.green.shade600
        : Colors.grey.shade400;

    // Hapus BlocBuilder, gunakan widget.habit dan state lokal untuk UI
    // karena kita ingin menahan perubahan isCompleted hingga tombol Simpan ditekan.

    return AlertDialog(
      title: Row(
        children: [
          Column(
            children: [
              // Gunakan state lokal isCompleted untuk menampilkan icon
              isCompleted
                  ? SvgPicture.asset(
                      'assets/vectors/flame_active.svg',
                      width: 30,
                      height: 30,
                    )
                  : SvgPicture.asset(
                      'assets/vectors/flame_nonactive.svg',
                      width: 30,
                      height: 30,
                    ),
              Text(
                widget.habit.streak.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text('D E T A I L', textAlign: TextAlign.center),
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
                onChanged: (_) => _checkForChanges(),
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Morning Exercise',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: Colors.black12, width: 1.5),
                  ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.black12, width: 1.5),
                    ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: Colors.black12, width: 1.5),
                  ),
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
                onChanged: _onFrequencyChanged,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue:
                    selectedCategory, // Gunakan value, bukan initialValue
                decoration: const InputDecoration(
                  labelText: 'Habit Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: Colors.black12, width: 1.5),
                  ),
                ),
                items: _buildCategoryItems(context),

                onChanged: _onCategoryChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'habit completed:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: isCompleted,
                    onChanged:
                        _onSwitchChanged, // Hanya memanggil setstate lokal
                    activeThumbColor: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: FilledButton.styleFrom(
            backgroundColor: saveButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: _hasChanges ? () => _onSavePressed(context) : null,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Text(
              'save'.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Habit?'),
                  content: const Text(
                    'Are you sure you want to delete this habit?',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () async {
                        context.read<HabitCubit>().deleteHabit(widget.habit.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Text(
              'delete'.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
