import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.grey),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.grey),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      minimumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(fontSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.primary, width: 2),
      foregroundColor: AppColors.primary,
      minimumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(fontSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.primaryDegrade,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    hintStyle: const TextStyle(color: AppColors.grey),
    labelStyle: const TextStyle(color: AppColors.secondary),
  ),
);
