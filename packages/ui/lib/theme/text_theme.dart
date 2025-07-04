import 'package:ui/theme/colors.dart';
import 'package:flutter/material.dart';

TextTheme getTextTheme(bool isDark) {
  Color textColor =
      isDark ? DarkThemePalette.primaryText : LightThemePalette.primaryText;
  Color blurredColor =
      isDark ? DarkThemePalette.lighterText : LightThemePalette.lighterText;
  Color grayColor = isDark ? DarkThemePalette.gray : LightThemePalette.gray;

  // Define the default font family for the entire theme
  const String defaultFontFamily = 'Inter';

  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      color: grayColor,
      fontFamily: defaultFontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: grayColor,
      fontFamily: defaultFontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: grayColor,
      fontFamily: defaultFontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 24,
      color: blurredColor,
      fontFamily: defaultFontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 19,
      color: blurredColor,
      fontFamily: defaultFontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: blurredColor,
      fontFamily: defaultFontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: textColor,
      fontFamily: defaultFontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: blurredColor,
      fontFamily: defaultFontFamily,
    ),
  );
}
