import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design direction: "Surgical Instrument Panel"
/// Inspired by high-end ultrasound machine UIs (GE Logiq, Philips EPIQ).
/// Deep dark surfaces, ultrasound-cyan accents, sharp geometric panels.
class AppTheme {
  // ── Core palette ──────────────────────────────────────────────
  static const Color cyan = Color(0xFF00D4FF);       // Primary — ultrasound display cyan
  static const Color cyanDim = Color(0xFF0A7EA4);    // Muted cyan for borders/subtle
  static const Color amber = Color(0xFFFFAA00);       // Favorites, warnings, attention
  static const Color surgicalRed = Color(0xFFFF3B5C); // Danger / avoid
  static const Color vitalGreen = Color(0xFF00E676);  // Success / complete
  static const Color accentTeal = Color(0xFF32ADE6);  // Legacy compat

  // ── Dark mode (default — US rooms are dark) ───────────────────
  static const Color bgDark = Color(0xFF080C18);       // Near-OLED black
  static const Color surfaceDark = Color(0xFF111827);   // Card/panel surface
  static const Color surfaceElevated = Color(0xFF1A2237); // Elevated panels
  static const Color borderDark = Color(0xFF1E293B);    // Subtle panel edges
  static const Color borderGlow = Color(0xFF00D4FF);    // Glow accent
  static const Color textPrimary = Color(0xFFE8ECF4);   // High-contrast body
  static const Color textSecondary = Color(0xFF8A96B0);  // Muted labels (4.5:1 on dark)
  static const Color textTertiary = Color(0xFF5A6A85);   // Faintest labels (3:1 on dark)

  // ── Light mode ────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF0F2F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFDDE1E9);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // ── Spacing scale ─────────────────────────────────────────────
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;

  // ── Radii (sharp, geometric — not bubbly) ─────────────────────
  static const double radiusSm = 6;
  static const double radiusMd = 10;
  static const double radiusLg = 14;

  // ── Shared text styles ────────────────────────────────────────
  static TextStyle get _monoLabel => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.8,
  );

  static TextStyle get _displayFont => GoogleFonts.inter(
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static TextStyle get _bodyFont => GoogleFonts.inter();

  // ── Category colors (per body region) ─────────────────────────
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'shoulder': return const Color(0xFF00D4FF);
      case 'elbow': return const Color(0xFF7B61FF);
      case 'hand': return const Color(0xFFFF6B9D);
      case 'hip': return const Color(0xFFFFAA00);
      case 'knee': return const Color(0xFF00E676);
      case 'foot': return const Color(0xFFFF6B35);
      default: return cyan;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: cyan,
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.dark(
        primary: cyan,
        secondary: amber,
        surface: surfaceDark,
        onSurface: textPrimary,
        error: surgicalRed,
        outline: borderDark,
        onPrimary: bgDark,
      ),
      textTheme: TextTheme(
        displaySmall: _displayFont.copyWith(color: textPrimary, fontSize: 28),
        headlineMedium: _displayFont.copyWith(color: textPrimary, fontSize: 22),
        titleLarge: _displayFont.copyWith(color: textPrimary, fontSize: 18),
        titleMedium: _bodyFont.copyWith(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        bodyLarge: _bodyFont.copyWith(color: textPrimary, fontSize: 14, height: 1.6),
        bodyMedium: _bodyFont.copyWith(color: textPrimary, fontSize: 13, height: 1.5),
        bodySmall: _bodyFont.copyWith(color: textSecondary, fontSize: 12),
        labelLarge: _monoLabel.copyWith(color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: cyan),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      dividerColor: borderDark,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cyan;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(bgDark),
        side: const BorderSide(color: textTertiary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cyan,
        linearTrackColor: borderDark,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    final cyanDark = const Color(0xFF006B8A);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: cyanDark,
      scaffoldBackgroundColor: bgLight,
      colorScheme: ColorScheme.light(
        primary: cyanDark,
        secondary: amber,
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        error: surgicalRed,
        outline: borderLight,
      ),
      textTheme: TextTheme(
        displaySmall: _displayFont.copyWith(color: textPrimaryLight, fontSize: 28),
        headlineMedium: _displayFont.copyWith(color: textPrimaryLight, fontSize: 22),
        titleLarge: _displayFont.copyWith(color: textPrimaryLight, fontSize: 18),
        titleMedium: _bodyFont.copyWith(color: textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 15),
        bodyLarge: _bodyFont.copyWith(color: textPrimaryLight, fontSize: 14, height: 1.6),
        bodyMedium: _bodyFont.copyWith(color: textPrimaryLight, fontSize: 13, height: 1.5),
        bodySmall: _bodyFont.copyWith(color: textSecondaryLight, fontSize: 12),
        labelLarge: _monoLabel.copyWith(color: textSecondaryLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: cyanDark),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      dividerColor: borderLight,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return cyanDark;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: textSecondaryLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cyanDark,
        linearTrackColor: borderLight,
      ),
    );
  }
}
