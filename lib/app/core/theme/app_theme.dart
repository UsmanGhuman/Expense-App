import 'package:flutter/material.dart';
import 'package:expense_app/app/core/theme/app_colors.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.onboardGreenColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.onboardGreenColor),

    // Tumhara wala inputDecorationTheme
    inputDecorationTheme:  InputDecorationTheme(
      filled: true,
      fillColor: AppColors.blackFilledColor,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.loginFiledBorderColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.loginFiledBorderColor, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.loginFiledBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.loginFiledBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),

    // Tumhara wala elevatedButtonTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.onboardGreenColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );

  // --- DARK THEME ---
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    // Dark theme mein agar input fields ka color change karna ho to yahan override kar lo
  );
}