import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FacebookLoginButton extends StatelessWidget {
  final Function? beforeLogin;

  FacebookLoginButton({super.key, this.beforeLogin});

  final authActionsController = Get.find<BaseAuthActionsController>();
  final authController = Get.find<BaseAuthController>();

  onLogin() {
    if (authController.user.value != null) {
      return;
    }
    if (beforeLogin != null) {
      beforeLogin!();
    }
    authActionsController.signInWithFacebook();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF1877F2),
        ), // Facebook blue color
      ),
      onPressed: () => onLogin(),
      child: Obx(
        () =>
            authController.validating.value
                ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.white,
                  ),
                )
                : const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ingresar con", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.facebook, color: Colors.white),
                  ],
                ),
      ),
    );
  }
}
