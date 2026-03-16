
import 'package:flutter/material.dart';

class AppTheme {
  // Arctic Frost Palette - Revamped for a structured, medical dashboard feel
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color backgroundLight = Color(0xFFF8F9FB); 
  static const Color cardWhite = Colors.white;
  static const Color textMain = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color dividerColor = Color(0xFFE5E5EA);
  static const Color accentTeal = Color(0xFF32ADE6);
  static const Color warningOrange = Color(0xFFFF9500);

  // Glassmorphism tokens - Refined
  static const Color glassBackground = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x1A007AFF); // Very subtle
  
  // Dark Mode Palette - Professional medical midnight theme
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textMainDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        surface: cardWhite,
        onSurface: textMain,
        secondary: accentTeal,
        error: Colors.redAccent,
        outline: dividerColor,
      ),
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        displaySmall: TextStyle(color: textMain, fontWeight: FontWeight.w800, letterSpacing: -1.0),
        headlineMedium: TextStyle(color: textMain, fontWeight: FontWeight.w700, fontSize: 24),
        titleLarge: TextStyle(color: textMain, fontWeight: FontWeight.w600, fontSize: 18),
        titleMedium: TextStyle(color: textMain, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: Color(0xFF424245), fontSize: 15, height: 1.5),
        bodyMedium: TextStyle(color: Color(0xFF424245), fontSize: 14),
        labelLarge: TextStyle(color: textSecondary, fontWeight: FontWeight.w500, letterSpacing: 1.1, fontSize: 11),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryBlue),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: dividerColor, width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        surface: surfaceDark,
        onSurface: textMainDark,
        secondary: accentTeal,
        outline: Colors.white10,
      ),
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        displaySmall: TextStyle(color: textMainDark, fontWeight: FontWeight.w800, letterSpacing: -1.0),
        headlineMedium: TextStyle(color: textMainDark, fontWeight: FontWeight.w700, fontSize: 24),
        titleLarge: TextStyle(color: textMainDark, fontWeight: FontWeight.w600, fontSize: 18),
        titleMedium: TextStyle(color: textMainDark, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: TextStyle(color: textMainDark, fontSize: 15, height: 1.5),
        bodyMedium: TextStyle(color: textMainDark, fontSize: 14),
        labelLarge: TextStyle(color: textSecondaryDark, fontWeight: FontWeight.w500, letterSpacing: 1.1, fontSize: 11),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryBlue),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white10, width: 1),
        ),
      ),
    );
  }
}
