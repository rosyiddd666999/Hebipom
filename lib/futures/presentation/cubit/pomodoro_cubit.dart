import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/pomodoro.dart';
import '../../domain/repo/pomodoro_repo.dart';

class PomodoroCubit extends Cubit<List<Pomodoro>> {
  final PomodoroRepo pomodoroRepo;
  PomodoroCubit(this.pomodoroRepo) : super([]) {
    loadPomodoros();
  }

  Future<void> loadPomodoros() async {
    try {
      final pomodoros = await pomodoroRepo.getAllPomodoros();
      emit(pomodoros);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> createPomodoro(Pomodoro newPomodoro) async {
    try {
      await pomodoroRepo.createPomodoro(newPomodoro);
      loadPomodoros();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updatePomodoro(Pomodoro pomodoro) async {
    try {
      await pomodoroRepo.updatePomodoro(pomodoro);
      loadPomodoros();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deletePomodoro(int pomodoroId) async {
    try {
      await pomodoroRepo.deletePomodoro(pomodoroId);
      loadPomodoros();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

 
}
