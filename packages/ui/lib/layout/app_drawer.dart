import 'package:flutter/material.dart';
import 'package:ui/widgets/brand/app_logo.dart';
import 'package:ui/widgets/button/toggle_theme.dart';

import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class BaseAppDrawer extends StatelessWidget {
  BaseAppDrawer({super.key});

  final BaseAuthController authController = Get.find<BaseAuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: AppLogo()),
          const ListTile(title: ToggleThemeButton()),
          ListTile(
            title: ElevatedButton(
              onPressed: authController.signout,
              child: const Text("Sign out"),
            ),
          ),
        ],
      ),
    );
  }
}
