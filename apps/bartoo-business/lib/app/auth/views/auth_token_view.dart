import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/brand/app_splash.dart';
import 'package:utils/log.dart';

import 'package:core/modules/auth/controllers/auth_token_screen_controller.dart';

class AuthTokenView extends GetView {
  const AuthTokenView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get.find<GuestGuardController>();
    Log('AuthTokenView');
    Get.find<AuthTokenScreenController>();

    return const AppSplash();
  }
}
