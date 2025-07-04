import 'package:ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbars {
  static void error({title = "ups, algo salio mal", message = '', icon}) =>
      Get.snackbar(
        title,
        message,
        icon: icon ?? const Icon(Icons.error),
        backgroundColor:
            Get.isDarkMode
                ? DarkThemePalette.errorColor
                : LightThemePalette.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

  static void success({title = "Registro exitoso", message = '', icon}) =>
      Get.snackbar(
        title,
        message,
        icon: icon ?? const Icon(Icons.check),
        backgroundColor:
            Get.isDarkMode
                ? DarkThemePalette.primary
                : LightThemePalette.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
}
