import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:ui/widgets/brand/app_splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends GetView<BaseAuthActionsController> {
  SplashView({super.key}) {
    controller.validateAuthForFirstRedirection();
  }

  @override
  Widget build(BuildContext context) {
    return const AppSplash();
  }
}
