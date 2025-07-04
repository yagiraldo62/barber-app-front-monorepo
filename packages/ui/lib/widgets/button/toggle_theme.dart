import 'package:ui/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(themeManager.isDark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        themeManager.toggleTheme();
      },
    );
  }
}
