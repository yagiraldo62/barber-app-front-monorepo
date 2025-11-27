import 'package:bartoo/app/auth/controllers/business_auth_guard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Middleware that validates auth state before accessing protected routes
class AuthGuardMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Get the guard controller and validate auth state
    final guardController = Get.find<BusinessAuthGuardController>();
    guardController.validateAuthState();

    // Don't redirect, just validate
    return null;
  }
}
