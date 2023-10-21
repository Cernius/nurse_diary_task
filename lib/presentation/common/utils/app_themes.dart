import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_diary/presentation/common/utils/text_styles.dart';

class AppTheme {
  static ThemeData themeData() {
    final textStyles = AppTextStyles();

    return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textStyles.button1,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: Colors.black),
      dividerColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
      scaffoldBackgroundColor: const Color(0xFFE6F7FF),
      textTheme: TextTheme(
        displayLarge: textStyles.h1,
        displayMedium: textStyles.h2,
        displaySmall: textStyles.h3,
        headlineMedium: textStyles.h4,
        headlineSmall: textStyles.h5,
        titleLarge: textStyles.h6,
        labelLarge: textStyles.button1,
        labelMedium: textStyles.button2,
        labelSmall: textStyles.button3,
        bodyLarge: textStyles.body1,
        bodyMedium: textStyles.body2,
        bodySmall: textStyles.body3,
      ),
    );
  }
}
