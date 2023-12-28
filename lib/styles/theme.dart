import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFFFEA202);
  static const secondaryColor = Color(0xFFFF6E4E);
  // #87643E
  static const thirdColor = Color(0xFF87643E);
  static const white = Colors.white;
}

class AppTheme {
  static final defaultTheme = ThemeData(
      useMaterial3: true,
      fontFamily:'Dubai' ,
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.primaryColor,
        ),
        titleMedium: TextStyle(
          color: AppColors.thirdColor,
        ),
        titleSmall: TextStyle(
          color: AppColors.thirdColor,
        ),
        bodyLarge: TextStyle(
          color: AppColors.thirdColor,
        ),
        bodyMedium: TextStyle(
          color: AppColors.thirdColor,
        ),
        bodySmall: TextStyle(
          color: AppColors.thirdColor,
        ),
        labelLarge: TextStyle(
          color: AppColors.thirdColor,
        ),
        labelMedium: TextStyle(
          color: AppColors.thirdColor,
        ),
        labelSmall: TextStyle(
          color: AppColors.thirdColor,
        ),
        displayLarge: TextStyle(
          color: AppColors.thirdColor,
        ),
        displayMedium: TextStyle(
          color: AppColors.thirdColor,
        ),
        displaySmall: TextStyle(
          color: AppColors.thirdColor,
        ),
        headlineLarge: TextStyle(
          color: AppColors.thirdColor,
        ),
        headlineMedium: TextStyle(
          color: AppColors.thirdColor,
        ),
        headlineSmall: TextStyle(
          color: AppColors.thirdColor,
        ),
        
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(AppColors.white),
          backgroundColor: MaterialStateProperty.all(AppColors.secondaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        //center the text
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        filled: true,
        fillColor: AppColors.white,
        border: InputBorder.none,
        alignLabelWithHint: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        labelStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,

        // You can add more styles as needed...
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
      ));
}
