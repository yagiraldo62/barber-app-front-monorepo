import 'package:ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeManager with ChangeNotifier {
  bool isDark = Get.isDarkMode;

  void toggleTheme() {
    // Toggle the isDark state first
    isDark = !isDark;

    // Apply the new theme
    if (isDark) {
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(darkTheme);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(lightTheme);
    }

    // Debug logging
    print('🎨 ThemeManager - Theme toggled to: ${isDark ? "Dark" : "Light"}');

    // Notify all listeners
    notifyListeners();
  }
}

ThemeManager themeManager = ThemeManager();
