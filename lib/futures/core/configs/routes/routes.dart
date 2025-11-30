import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/futures/habit/presentation/page/notif_page.dart';

import '../../../habit/presentation/page/habit_page.dart';
import '../../../habit/presentation/page/theme_page.dart';
import 'intro/permission_setup_screen.dart';
import '../../services/notivication_service.dart';
import 'intro/permission_check.dart';
import 'intro/splash_screen.dart';

part 'routes_name.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter habitRouter(NotificationService notificationService) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.permissionSetup,
        name: 'permission_setup',
        builder: (context, state) => PermissionSetupPage(
          notificationService: notificationService,
          onCompleted: () {
            context.go(RouteNames.home);
          },
        ),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => HabitPage(),
      ),
      GoRoute(
        path: RouteNames.theme,
        name: 'theme',
        builder: (context, state) => const ThemePage(),
      ),
      GoRoute(
        path: RouteNames.notification,
        name: 'notification',
        builder: (context, state) => NotificationPage(notificationService: notificationService,),
      ),
    ],
  );
}