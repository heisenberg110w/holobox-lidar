import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: AppColors.primarySwatch,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      // ADD FONT FAMILY HERE
      fontFamily: 'SF Pro Display',

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display', // Add here too
        ),
        iconTheme: IconThemeData(
          color: AppColors.textDark,
          size: 24,
        ),
      ),

      // Simple card theme that works
      cardColor: AppColors.white,

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'SF Pro Display', // Add here
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text theme with SF Pro Display
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        titleMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
        titleSmall: TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
        headlineLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        headlineSmall: TextStyle(
          color: AppColors.textDark,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textDark,
        size: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: AppColors.primarySwatch,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: 'SF Pro Display', // Add here too

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.darkTextPrimary,
          fontFamily: 'SF Pro Display',
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkTextPrimary,
          fontFamily: 'SF Pro Display',
        ),
        bodySmall: TextStyle(
          color: AppColors.darkTextSecondary,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }
}

class AppCupertinoTheme {
  static const CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryPurple,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    // Note: Cupertino themes don't have fontFamily property
    // but individual Text widgets can specify it
  );
}
