import 'package:flutter/material.dart';

class LifeOsColors {
  static const background = Color(0xFFF6F7F2);
  static const surface = Colors.white;
  static const primary = Color(0xFF4D8C73);
  static const primarySoft = Color(0xFFD9EBE2);
  static const warning = Color(0xFFE8BF65);
  static const danger = Color(0xFFE07A7A);
  static const textPrimary = Color(0xFF202520);
  static const textSecondary = Color(0xFF68706A);
  static const border = Color(0xFFE6E8E1);
}

ThemeData buildLifeOsTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: LifeOsColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LifeOsColors.primary,
      primary: LifeOsColors.primary,
      secondary: LifeOsColors.warning,
      error: LifeOsColors.danger,
      surface: LifeOsColors.surface,
      brightness: Brightness.light,
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: LifeOsColors.textPrimary,
        height: 1.1,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: LifeOsColors.textPrimary,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: LifeOsColors.textPrimary,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: LifeOsColors.textPrimary,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: LifeOsColors.textSecondary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: LifeOsColors.textPrimary,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: LifeOsColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: LifeOsColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LifeOsColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: LifeOsColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: LifeOsColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: LifeOsColors.primary, width: 1.2),
      ),
      hintStyle: const TextStyle(color: LifeOsColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LifeOsColors.textPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      side: BorderSide.none,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LifeOsColors.surface,
      selectedItemColor: LifeOsColors.textPrimary,
      unselectedItemColor: LifeOsColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
