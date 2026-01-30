import 'package:flutter/material.dart';

class ThemeHabit {
  static const Color primaryButtonColor = Color.fromARGB(255, 255, 153, 0);
  static const Color onPrimaryButtonColor = Colors.white;
  static const Color habitCompnentLightVariant1 = Color(0xFF3DCF3D);
  static const Color habitCompnentLightVariant2 = Color(0xFF6D85D5);
  static const Color habitCompnentLightVariant3 = Color(0xFFCA36D5);
  static const Color habitCompnentLightVariant4 = Color(0xFFE25656);
  static const Color habitCompnentDarkVariant1 = Color(0xFF9EFF9E);
  static const Color habitCompnentDarkVariant2 = Color(0xFFBBCBFF);
  static const Color habitCompnentDarkVariant3 = Color(0xFFF9BBFF);
  static const Color habitCompnentDarkVariant4 = Color(0xFFFF8888);

  static ThemeData _buildTheme(Brightness brightnessColor) {
    final bool isLight = brightnessColor == Brightness.light;
    final Color primary = isLight
        ? Colors.orange.shade500
        : Colors.orange.shade600;
    final Color secondaryColor = isLight
        ? Colors.grey.shade200
        : Colors.grey.shade700;
    final Color surfaceColor = isLight
        ? Colors.grey.shade400
        : Colors.grey.shade800;
    final Color onSurfaceColor = isLight ? Colors.black87 : Colors.white70;

    return ThemeData(
      brightness: brightnessColor,
      scaffoldBackgroundColor: isLight
          ? Colors.grey.shade300
          : Colors.grey.shade900,
      primaryColor: primary,
      appBarTheme: AppBarTheme(backgroundColor: secondaryColor),
      colorScheme: ColorScheme(
        brightness: brightnessColor,
        primary: primary,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: onPrimaryButtonColor,
        onSecondary: onSurfaceColor,
        onSurface: onSurfaceColor,
        error: Colors.red,
        onError: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryButtonColor,
          foregroundColor: onPrimaryButtonColor,
          padding: const EdgeInsets.all(25),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Colors.black12, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: isLight ? Colors.grey.shade600 : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: isLight ? Colors.grey.shade700 : Colors.grey.shade400,
        ),
        hintStyle: TextStyle(
          color: isLight ? Colors.grey.shade500 : Colors.grey.shade400,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      dialogTheme: DialogThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 5,
        backgroundColor: secondaryColor,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: isLight ? Colors.black : Colors.white,
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: secondaryColor,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),

      textTheme: TextTheme(
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          color: isLight ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: onSurfaceColor),
        bodySmall: TextStyle(
          fontSize: 12,
          color: isLight ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),

      iconTheme: IconThemeData(
        color: isLight ? Colors.grey.shade600 : Colors.grey.shade400,
      ),
    );
  }

  static ThemeData lightMode = _buildTheme(Brightness.light);
  static ThemeData darkMode = _buildTheme(Brightness.dark);
}
