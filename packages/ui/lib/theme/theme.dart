import 'package:ui/theme/colors.dart';
import 'package:ui/theme/text_theme.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkThemePalette.backgroundColor,
  colorScheme: ColorScheme.dark(
    primary: DarkThemePalette.primary,
    secondary: DarkThemePalette.secondary,
    primaryContainer: DarkThemePalette.paperColor,
    errorContainer: DarkThemePalette.errorColor,
  ),
  textTheme: getTextTheme(true),
  appBarTheme: AppBarTheme(backgroundColor: DarkThemePalette.backgroundColor),
  cardTheme: CardTheme(
    color: DarkThemePalette.paperColor,
    surfaceTintColor: DarkThemePalette.paperColor,
    // shadowColor: DarkThemePalette.shadowColor,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      //set border radius more than 50% of height and width to make circle
    ),
    // color: DarkThemePalette.paperColor,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: DarkThemePalette.primary,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
);

// ThemeData lightTheme = darkTheme;
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightThemePalette.backgroundColor,
  colorScheme: ColorScheme.light(
    primary: LightThemePalette.primary,
    secondary: LightThemePalette.secondary,
    primaryContainer: LightThemePalette.paperColor,
    errorContainer: DarkThemePalette.errorColor,
  ),
  textTheme: getTextTheme(false),
  appBarTheme: AppBarTheme(
    backgroundColor: LightThemePalette.backgroundColor,
    toolbarTextStyle: TextStyle(color: LightThemePalette.primaryText),
    titleTextStyle: TextStyle(color: LightThemePalette.primaryText),
    iconTheme: IconThemeData(color: LightThemePalette.primaryText),
  ),
  cardTheme: CardTheme(
    color: LightThemePalette.paperColor,
    surfaceTintColor: LightThemePalette.paperColor,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      //set border radius more than 50% of height and width to make circle
    ),
    // color: LightThemePalette.paperColor,
  ),
);
