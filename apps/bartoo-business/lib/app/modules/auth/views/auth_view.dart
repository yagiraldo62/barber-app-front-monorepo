import 'package:bartoo/app/modules/auth/controllers/business_guest_guard_controller.dart';
import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AuthView extends GetView {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.find<BusinessGuestGuardController>();
    var authActionsController = Get.find<BaseAuthActionsController>();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(0xFF1877F2),
            ), // Facebook blue color
          ),
          onPressed: () => authActionsController.signInWithFacebook(),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login with Facebook",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 8),
              Icon(Icons.facebook, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
