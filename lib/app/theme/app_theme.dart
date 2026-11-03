import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Restrained, Apple-inspired design tokens. The palette is deliberately
/// monochrome with a single warm bronze accent so dense business tables stay
/// readable and printed documents remain black on white.
abstract final class AppColors {
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F5F5);
  static const lightBorder = Color(0xFFE5E5E5);
  static const lightText = Color(0xFF111111);
  static const lightSecondary = Color(0xFF666666);

  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF1A1A1A);
  static const darkBorder = Color(0xFF333333);
  static const darkText = Color(0xFFFFFFFF);
  static const darkSecondary = Color(0xFFAAAAAA);

  static const accent = Color(0xFF9A6B2F);
  static const accentSoft = Color(0xFFF3E9DC);
  static const success = Color(0xFF1F7A4D);
  static const successSoft = Color(0xFFE6F3EC);
  static const warning = Color(0xFF9A6A00);
  static const warningSoft = Color(0xFFFBF1DA);
  static const danger = Color(0xFFB3261E);
  static const dangerSoft = Color(0xFFFBE9E7);
  static const info = Color(0xFF2B5F9E);
  static const infoSoft = Color(0xFFE8F0FA);
}

abstract final class AppRadius {
  static const double card = 16;
  static const double field = 12;
  static const double pill = 999;
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

ThemeData buildLightTheme() => _base(
  brightness: Brightness.light,
  background: AppColors.lightBackground,
  surface: AppColors.lightSurface,
  border: AppColors.lightBorder,
  text: AppColors.lightText,
  secondary: AppColors.lightSecondary,
);

ThemeData buildDarkTheme() => _base(
  brightness: Brightness.dark,
  background: AppColors.darkBackground,
  surface: AppColors.darkSurface,
  border: AppColors.darkBorder,
  text: AppColors.darkText,
  secondary: AppColors.darkSecondary,
);

ThemeData _base({
  required Brightness brightness,
  required Color background,
  required Color surface,
  required Color border,
  required Color text,
  required Color secondary,
}) {
  final isDark = brightness == Brightness.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: isDark ? Colors.white : AppColors.lightText,
      onPrimary: isDark ? Colors.black : Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: background,
      onSurface: text,
      surfaceContainerHighest: surface,
      outline: border,
      outlineVariant: border,
    ),
  );

  final textTheme = base.textTheme
      .apply(bodyColor: text, displayColor: text)
      .copyWith(
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 34,
          height: 1.1,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.1,
          color: text,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 26,
          height: 1.15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: text,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 21,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: text,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: text,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(fontSize: 15, height: 1.4, color: text),
        bodyMedium: TextStyle(fontSize: 13.5, height: 1.4, color: text),
        bodySmall: TextStyle(fontSize: 12, height: 1.35, color: secondary),
        labelLarge: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelSmall: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: secondary,
        ),
      );

  return base.copyWith(
    textTheme: textTheme,
    dividerColor: border,
    dividerTheme: DividerThemeData(color: border, thickness: 0.7, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: background,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: border, width: 0.8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(
        fontSize: 13.5,
        color: secondary.withValues(alpha: 0.7),
      ),
      labelStyle: TextStyle(fontSize: 13.5, color: secondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: BorderSide(color: border, width: 0.7),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: BorderSide(
          color: isDark ? Colors.white : AppColors.accent,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: isDark ? Colors.white : AppColors.lightText,
        foregroundColor: isDark ? Colors.black : Colors.white,
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        minimumSize: const Size(0, 48),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: isDark ? Colors.white : AppColors.accent,
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: background,
      elevation: 0,
      height: 64,
      indicatorColor: surface,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? text : secondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: states.contains(WidgetState.selected) ? text : secondary,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: background,
      indicatorColor: surface,
      selectedIconTheme: IconThemeData(color: text, size: 22),
      unselectedIconTheme: IconThemeData(color: secondary, size: 22),
      selectedLabelTextStyle: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: text,
      ),
      unselectedLabelTextStyle: TextStyle(fontSize: 11.5, color: secondary),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: isDark ? Colors.white : AppColors.lightText,
      labelStyle: TextStyle(fontSize: 12, color: text),
      secondaryLabelStyle: TextStyle(
        fontSize: 12,
        color: isDark ? Colors.black : Colors.white,
      ),
      side: BorderSide(color: border, width: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightText,
      contentTextStyle: TextStyle(
        color: isDark ? AppColors.darkText : Colors.white,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      iconColor: secondary,
      titleTextStyle: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: textTheme.bodySmall,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: isDark ? Colors.white : AppColors.lightText,
      linearTrackColor: surface,
    ),
  );
}
