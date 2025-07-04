import 'package:ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeManager with ChangeNotifier {
  bool isDark = Get.isDarkMode;
  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    isDark = !Get.isDarkMode;
    notifyListeners();
  }
}

ThemeManager themeManager = ThemeManager();
