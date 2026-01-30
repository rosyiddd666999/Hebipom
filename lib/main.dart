import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hebipom/futures/data/repo/pomodoro_repo_impl.dart';
import 'package:hebipom/futures/domain/repo/pomodoro_repo.dart';
import 'package:hebipom/futures/presentation/cubit/pomodoro_cubit.dart';
import 'package:hebipom/futures/presentation/cubit/theme_cubit.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'core/configs/routes/routes.dart';
import 'core/configs/themes/themes.dart';
import 'core/services/notivication_service.dart';
import 'futures/data/model/isar_habit.dart';
import 'futures/data/model/isar_pomodoro.dart';
import 'futures/data/repo/habit_repo_impl.dart';
import 'futures/domain/repo/habit_repo.dart';
import 'futures/presentation/cubit/habit_cubit.dart';
import 'futures/presentation/cubit/pomodoro_timer_ui/pomodoro_timer_ui_cubit.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  debugPrint('Notification tapped in background: ${response.payload}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    tz.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');
    tz.setLocalLocation(jakarta);

    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([
      HabitIsarSchema,
      PomodoroIsarSchema,
    ], directory: dir.path);

    final habitRepo = HabitRepoImpl(isar);
    final pomoRepo = PomodoroRepoImpl(isar);

    final NotificationService notifService = NotificationService();
    await notifService.initNotification();

    await initializeDateFormatting('id_ID', null);

    runApp(
      BlocProvider(
        create: (context) => ThemeCubit(),
        child: MyApp(
          habitRepo: habitRepo,
          notificationService: notifService,
          pomodoroRepo: pomoRepo,
        ),
      ),
    );
  } catch (e, stack) {
    debugPrint('Fatal Initialization Error: $e');
    debugPrint('Stack: $stack');
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Initialization Error! Check Logs.')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final HabitRepo habitRepo;
  final PomodoroRepo pomodoroRepo;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.habitRepo,
    required this.pomodoroRepo,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: habitRepo),
        RepositoryProvider.value(value: notificationService),
        RepositoryProvider.value(value: pomodoroRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HabitCubit>(
            create: (context) => HabitCubit(habitRepo, notificationService),
          ),
          BlocProvider(create: (context) => PomodoroCubit(pomodoroRepo)),
          BlocProvider<PomodoroTimerUiCubit>(
            create: (context) => PomodoroTimerUiCubit(
              phases: [],
              pomodoroId: 0,
              pomodoroRepo: pomodoroRepo,
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Hebipom - Habit Pomodoro',
              debugShowCheckedModeBanner: false,
              theme: ThemeHabit.lightMode,
              darkTheme: ThemeHabit.darkMode,
              themeMode: state.themeMode,
              routerConfig: habitRouter(notificationService),
            );
          },
        ),
      ),
    );
  }
}
