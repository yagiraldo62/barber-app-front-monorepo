import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/avatar/user_avatar.dart';
import 'package:utils/log.dart';

class AuthUserAvatar extends StatelessWidget {
  final Widget alternativeWidget;
  final int size;

  final authController = Get.find<BaseAuthController>();

  AuthUserAvatar({
    super.key,
    this.alternativeWidget = const CircularProgressIndicator(),
    this.size = 60,
  });

  // Note: These controllers need to be injected from the app layer
  // final authController = Get.find<AuthController>();
  final progressIndicator = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    String? src = authController.user.value?.photoURL;
    Log('image src for AuthUserAvatar: $src');
    return (src != "") ? UserAvatar(src: src, size: size) : alternativeWidget;
  }
}
