import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/avatar/auth_user_avatar.dart';
import 'package:ui/widgets/brand/bartoo_app_name.dart';

import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/modules/auth/widgets/facebook_login_button.dart';
import 'package:ui/widgets/button/toggle_theme.dart';
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
  Size get preferredSize =>
      back
          ? const Size.fromHeight(kToolbarHeight / 1.3)
          : const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    Log('BaseAppBar: back: $back, title: $title');
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
      backgroundColor:
          back
              ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)
              : Theme.of(context).scaffoldBackgroundColor,
      actions: [
        ToggleThemeButton(),
        const SizedBox(width: 10),
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
