import 'package:core/modules/auth/controllers/base_auth_actions_controller.dart';
import 'package:get/get.dart';

class AuthTokenScreenController extends GetxController {
  final BaseAuthActionsController authActionsController =
      Get.find<BaseAuthActionsController>();

  AuthTokenScreenController();

  ///  Get the token from the URL and sign in
  void validateAndSignin() {
    final token = Uri.base.pathSegments.last;
    authActionsController.signinWithToken(token);
  }

  @override
  void onInit() {
    super.onInit();

    validateAndSignin();
  }
}
