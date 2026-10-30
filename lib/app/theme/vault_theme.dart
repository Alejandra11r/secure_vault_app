import 'package:flutter/material.dart';

abstract final class VaultColors {
  static const background = Color(0xFF07111F);
  static const surface = Color(0xFF101D2E);
  static const surfaceRaised = Color(0xFF15243A);
  static const border = Color(0xFF263B58);
  static const blue = Color(0xFF4D7CFE);
  static const violet = Color(0xFF8B5CF6);
  static const muted = Color(0xFF93A6C2);
  static const text = Color(0xFFEAF1FF);
}

abstract final class VaultTheme {
  static ThemeData get dark {
    final scheme = const ColorScheme.dark(
      primary: VaultColors.blue,
      secondary: VaultColors.violet,
      surface: VaultColors.surface,
      error: Color(0xFFFF6B7A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: VaultColors.text,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: VaultColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: VaultColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: VaultColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VaultColors.surface,
        labelStyle: const TextStyle(color: VaultColors.muted),
        hintStyle: const TextStyle(color: VaultColors.muted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: VaultColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: VaultColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: VaultColors.blue, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: VaultColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: VaultColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VaultColors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VaultColors.text,
          side: const BorderSide(color: VaultColors.border),
          minimumSize: const Size(48, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF88AFFF)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xCC10213A),
        indicatorColor: VaultColors.blue.withValues(alpha: 0.2),
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? VaultColors.text
                  : VaultColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: VaultColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: VaultColors.border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF29466F),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: const Color(0xFFBFD2FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerColor: VaultColors.border,
    );
  }
}
