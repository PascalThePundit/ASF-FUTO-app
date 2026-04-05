import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.white,
      ),

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // ── Bottom Nav ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Cards ──
      cardTheme: CardTheme(
        color: AppColors.glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),

      // ── Elevated Button (pill shape) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          textStyle: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: AppColors.gold, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input Fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.textHint,
          fontSize: 15,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassWhite,
        selectedColor: AppColors.gold.withOpacity(0.2),
        labelStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.textPrimary,
          fontSize: 12,
        ),
        side: const BorderSide(color: AppColors.glassBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── Icon ──
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),

      // ── Snackbar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: const TextStyle(
          fontFamily: 'DMSans',
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ──
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),

      // ── Tab Bar ──
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textHint,
        indicatorColor: AppColors.gold,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // ── Typography ──
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Gabarito', fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        displayMedium: TextStyle(fontFamily: 'Gabarito', fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        displaySmall: TextStyle(fontFamily: 'Gabarito', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        headlineLarge: TextStyle(fontFamily: 'Gabarito', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        headlineMedium: TextStyle(fontFamily: 'Gabarito', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        headlineSmall: TextStyle(fontFamily: 'Gabarito', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontFamily: 'DMSans', fontSize: 16, color: AppColors.textPrimary, height: 1.5),
        bodyMedium: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: AppColors.textPrimary, height: 1.5),
        bodySmall: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: AppColors.textSecondary, height: 1.5),
        labelLarge: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        labelMedium: TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        labelSmall: TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textHint),
      ),
    );
  }

  // Keep light as alias for dark — app is dark-first
  static ThemeData get light => dark;
}