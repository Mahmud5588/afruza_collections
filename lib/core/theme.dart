import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

ThemeData buildAppTheme() {
  const colors = _AppColors();

  final textTheme = TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: colors.charcoal,
      height: 1.1,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: colors.charcoal,
    ),
    titleMedium: GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colors.charcoal,
    ),
    bodyLarge: GoogleFonts.sourceSans3(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: colors.charcoal,
    ),
    bodyMedium: GoogleFonts.sourceSans3(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: colors.charcoal,
    ),
    labelLarge: GoogleFonts.sourceSans3(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: colors.charcoal,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.gold,
      primary: colors.charcoal,
      secondary: colors.gold,
      surface: colors.cream,
      background: colors.cream,
      surfaceVariant: colors.creamDark,
      outline: colors.ink.withOpacity(0.25),
      error: const Color(0xFFB24C3B),
      onPrimary: colors.cream,
      onSecondary: colors.charcoal,
      onSurface: colors.charcoal,
    ),
    scaffoldBackgroundColor: colors.cream,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.cream,
      foregroundColor: colors.charcoal,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.cream,
      selectedItemColor: colors.charcoal,
      unselectedItemColor: colors.ink.withOpacity(0.55),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showUnselectedLabels: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.creamDark,
      selectedColor: colors.gold,
      labelStyle: textTheme.bodyMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.creamDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle:
          textTheme.bodyMedium?.copyWith(color: colors.charcoal.withOpacity(0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIconColor: colors.ink.withOpacity(0.6),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.charcoal,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.charcoal,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.cream),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class _AppColors {
  const _AppColors();

  final Color cream = const Color(0xFFF7F3EE);
  final Color creamDark = const Color(0xFFECE4DA);
  final Color charcoal = const Color(0xFF1E1C1A);
  final Color gold = const Color(0xFFC9A86A);
  final Color ink = const Color(0xFF3A352F);
}
