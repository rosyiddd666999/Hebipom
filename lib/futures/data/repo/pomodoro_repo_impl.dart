import 'package:hebipom/futures/domain/entity/pomodoro.dart';
import 'package:isar_community/isar.dart';

import '../../domain/repo/pomodoro_repo.dart';
import '../model/isar_pomodoro.dart';

class PomodoroRepoImpl implements PomodoroRepo {
  final Isar db;
  PomodoroRepoImpl(this.db);
  @override
  Future<void> createPomodoro(Pomodoro pomodoro) async {
    final pomodoroIsar = PomodoroIsar.fromEntity(pomodoro);
    await db.writeTxn(() => db.pomodoroIsars.put(pomodoroIsar));
  }

  @override
  Future<void> deletePomodoro(int pomodoroId) async {
    await db.writeTxn(() => db.pomodoroIsars.delete(pomodoroId));
  }

  @override
  Future<void> updatePomodoro(Pomodoro pomodoro) async {
    final pomodoroIsar = PomodoroIsar.fromEntity(pomodoro);
    await db.writeTxn(() => db.pomodoroIsars.put(pomodoroIsar));
  }

  @override
  Future<List<Pomodoro>> getAllPomodoros() async{
    final pomodoros = await db.pomodoroIsars.where().findAll();
    return pomodoros.map((p) => p.toEntity()).toList();
  }

  @override
  Future<Pomodoro?> getPomodoroById(int pomodoroId) async {
    final pomodoro = await db.pomodoroIsars.get(pomodoroId);
    return pomodoro?.toEntity();
  }
}
