import 'package:bartoo/app/auth/controllers/business_guest_guard_controller.dart';
import 'package:bartoo/app/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AuthView extends GetView {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.find<BusinessGuestGuardController>();

    return AuthScreen();
  }
}
