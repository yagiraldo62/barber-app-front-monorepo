import 'package:bartoo/app/auth/controllers/business_auth_actions_controller.dart';
import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/auth/controllers/business_auth_guard_controller.dart';
import 'package:bartoo/app/auth/controllers/business_guest_guard_controller.dart';
import 'package:bartoo/app/auth/controllers/business_auth_intro_controller.dart';
import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/modules/auth/controllers/auth_token_screen_controller.dart';
import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:core/modules/auth/providers/auth_provider.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:get/get.dart';

/// Business app specific auth binding
class BusinessAuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core auth dependencies
    Get.put<AuthProvider>(AuthProvider());
    Get.put<UserRepository>(UserRepository());
    Get.put<AuthRepository>(AuthRepository());

    // Business-specific auth controller
    Get.put<BaseAuthController>(
      Get.put<BusinessAuthController>(BusinessAuthController()),
    );
    // Legacy compatibility - register the old AuthController with the new implementation
    Get.lazyPut<AuthTokenScreenController>(() => AuthTokenScreenController());

    // Business-specific auth controllers
    Get.put<BusinessAuthIntroController>(BusinessAuthIntroController());
    Get.put<BaseAuthActionsController>(BusinessAuthActionsController());
    Get.put<BusinessAuthGuardController>(BusinessAuthGuardController());
    Get.lazyPut<BusinessGuestGuardController>(
      () => BusinessGuestGuardController(),
    );
  }
}
