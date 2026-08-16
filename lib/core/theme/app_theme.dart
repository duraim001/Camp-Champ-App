import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// AppTheme builds the ThemeData for Camp Champ app.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        primary: AppColors.primaryPurple,
        secondary: AppColors.gold,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.secondaryText,
          fontSize: 14,
        ),
      ),
    );
  }
}
