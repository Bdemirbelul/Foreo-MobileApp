import 'package:flutter/material.dart';

class AppTheme {
  // Modern Color Scheme with gradients
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF808080);

  // Modern accent colors
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentPink = Color(0xFFFF6B9D);

  // Gradient colors
  static const List<Color> darkGradient = [
    Color(0xFF0A0A0A),
    Color(0xFF1A1A1A),
    Color(0xFF000000),
  ];

  static const List<Color> lightGradient = [
    Color(0xFFF8F9FA),
    Color(0xFFFFFFFF),
    Color(0xFFE8E8E8),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFF0066FF),
    Color(0xFF6C5CE7),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: black,
        secondary: darkGray,
        surface: white,
        background: lightGray,
        error: black,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onBackground: black,
        onError: white,
      ),
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: black, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: black,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: black, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: black, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: black, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: black, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: black, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: black, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: black, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: black, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: black, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: black, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: black),
        bodyMedium: TextStyle(color: black),
        bodySmall: TextStyle(color: mediumGray),
        labelLarge: TextStyle(color: black, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: black),
        labelSmall: TextStyle(color: mediumGray),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: white,
        indicatorColor: black,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: white, fontWeight: FontWeight.w600);
          }
          return const TextStyle(
            color: mediumGray,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: white);
          }
          return const IconThemeData(color: mediumGray);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: white,
        secondary: lightGray,
        surface: darkGray,
        background: black,
        error: white,
        onPrimary: black,
        onSecondary: black,
        onSurface: white,
        onBackground: white,
        onError: black,
      ),
      scaffoldBackgroundColor: black,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGray,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkGray,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: white, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: white, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: white, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: white, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: white, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: white, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: white, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: white, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: white, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: white, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: white, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: white, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: white),
        bodySmall: TextStyle(color: mediumGray),
        labelLarge: TextStyle(color: white, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: white),
        labelSmall: TextStyle(color: mediumGray),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkGray,
        indicatorColor: white,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: black, fontWeight: FontWeight.w600);
          }
          return const TextStyle(
            color: mediumGray,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: black);
          }
          return const IconThemeData(color: mediumGray);
        }),
      ),
    );
  }
}
