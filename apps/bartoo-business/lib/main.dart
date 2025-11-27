import 'package:bartoo/app/auth/bindings/business_auth_binding.dart';
import 'package:utils/initialize_services.dart';
import 'package:flutter/material.dart';
import 'package:ui/theme/theme.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await initializeServices();

  ThemeData themeData = Get.isDarkMode ? lightTheme : darkTheme;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      darkTheme: darkTheme,
      title: "Application",
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      initialBinding: BusinessAuthBinding(),
    ),
  );
}
