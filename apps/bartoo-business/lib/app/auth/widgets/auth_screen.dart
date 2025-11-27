import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:core/modules/auth/widgets/facebook_login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final authActionsController = Get.find<BaseAuthActionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FacebookLoginButton()));
  }
}
