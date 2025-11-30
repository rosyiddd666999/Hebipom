import 'package:flutter/material.dart';

class ThemeHabit {
  static const Color primaryButtonColor = Color.fromARGB(255, 255, 153, 0);
  static const Color onPrimaryButtonColor = Colors.white;

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    final Color primary = isLight
        ? Colors.orange.shade500
        : Colors.orange.shade300;
    final Color secondary = isLight
        ? Colors.grey.shade50
        : Colors.grey.shade600;
    final Color surfaceColor = isLight
        ? Colors.grey.shade400
        : Colors.grey.shade800;
    final Color onSurfaceColor = isLight ? Colors.black87 : Colors.white70;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: isLight
          ? Colors.grey.shade300
          : Colors.grey.shade900,
      primaryColor: primary,
      appBarTheme: AppBarTheme(backgroundColor: secondary),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        secondary: secondary,
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
            color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
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
        backgroundColor: secondary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: isLight ? Colors.black : Colors.white,
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: secondary,

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
