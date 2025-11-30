import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notivication_service.dart';

class PermissionChecker {
  static Future<bool> needsPermissionSetup(NotificationService notificationService) async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedSetup = prefs.getBool('permissions_setup_completed') ?? false;

    if (hasCompletedSetup) {
      return false;
    }

    final permissions = await notificationService.checkAllPermissions();
    final allGranted = permissions.values.every((granted) => granted);

    if (allGranted) {
      await prefs.setBool('permissions_setup_completed', true);
      return false;
    }

    return true;
  }
}