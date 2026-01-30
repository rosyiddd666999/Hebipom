import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/futures/presentation/page/pomodoro/pomodoro_page.dart';
import 'package:hebipom/futures/presentation/page/settings/details/history_page.dart';
import 'package:hebipom/futures/presentation/page/settings/details/notif_page.dart';
import 'package:hebipom/futures/presentation/page/settings/details/theme_page.dart';
import '../../../futures/presentation/page/habit/habit_page.dart';
import 'intro/onboarding_setup_screen.dart';
import '../../services/notivication_service.dart';
import 'intro/permission_check.dart';
import 'intro/splash_screen.dart';

part 'routes_name.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter habitRouter(NotificationService notificationService) {
  return GoRouter(
    navigatorKey: _shellNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: (context, state) async {
      final needsSetup = await PermissionChecker.needsPermissionSetup(
        notificationService,
      );
      if (state.matchedLocation == RouteNames.splash) {
        return null;
      }
      if (needsSetup && state.matchedLocation != RouteNames.permissionSetup) {
        return RouteNames.permissionSetup;
      }
      if (!needsSetup && state.matchedLocation == RouteNames.permissionSetup) {
        return RouteNames.habit;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.habit,
        name: 'habit',
        builder: (context, state) => const HabitPage(),
        routes: [
          GoRoute(
            path: RouteNames.pomodoro,
            name: 'pomodoro',
            builder: (context, state) => const PomodoroPage(),
          ),
          GoRoute(
            path: RouteNames.theme,
            name: 'theme',
            builder: (context, state) => const ThemePage(),
          ),
          GoRoute(
            path: RouteNames.history,
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: RouteNames.notificationPermissions,
            name: 'notification-permissions',
            builder: (context, state) =>
                PermissionPage(notificationService: notificationService),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.permissionSetup,
        name: 'permission_setup',
        builder: (context, state) => OnboardingPage(
          notificationService: notificationService,
          onCompleted: () {
            context.go(RouteNames.habit);
          },
        ),
      ),
    ],
  );
}
