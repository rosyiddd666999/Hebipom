import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class PermissionChecker {
  /// Check apakah user perlu setup permission (untuk routing initial)
  static Future<bool> needsPermissionSetup(
    NotificationService notificationService,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedSetup =
        prefs.getBool('permissions_setup_completed') ?? false;

    // Jika sudah pernah complete, tetap validate ulang permission-nya
    // (case: user revoke permission setelah setup)
    final permissions = await notificationService.checkAllPermissions();
    
    final allGranted = permissions.values.every((granted) => granted);

    // Update SharedPreferences based on current state
    if (allGranted && !hasCompletedSetup) {
      await prefs.setBool('permissions_setup_completed', true);
    } else if (!allGranted && hasCompletedSetup) {
      // Permission di-revoke, reset flag
      await prefs.setBool('permissions_setup_completed', false);
    }

    return !allGranted;
  }

  /// Mark permission setup as completed
  static Future<void> markSetupCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_setup_completed', true);
  }

  /// Reset permission setup flag (untuk testing atau force re-setup)
  static Future<void> resetSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_setup_completed', false);
  }
}