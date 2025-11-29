import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/avatar/auth_user_avatar.dart';
import 'package:ui/widgets/brand/bartoo_app_name.dart';

import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/modules/auth/widgets/facebook_login_button.dart';
import 'package:ui/widgets/button/toggle_theme.dart';
import 'package:ui/widgets/app_bar/scope_selector.dart';
import 'package:utils/log.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  BaseAppBar({
    super.key,
    this.back = false,
    this.title, // Nuevo parámetro
  });
  final bool back;
  final String? title; // Nuevo parámetro
  final authController = Get.find<BaseAuthController>();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          back
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      leadingWidth: back ? null : 24 * 2 + 16,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: const BartooAppName(size: 24),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Obx(
          () =>
              authController.user.value != null
                  ? const ScopeSelector()
                  : const SizedBox.shrink(),
        ),
        // ToggleThemeButton(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(
            () =>
                authController.user.value != null
                    ? AuthUserAvatar(size: 40)
                    : FacebookLoginButton(),
          ),
        ),
      ],
    );
  }
}
