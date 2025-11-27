import 'dart:async';

import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:get/get.dart';

enum UserType { artist, organization, member, client }

class BaseAuthIntroController extends GetxController {
  Rx<UserModel?> user = Get.find<BaseAuthController>().user;
  Rx<bool> validating = false.obs;

  final AuthRepository authRepository = Get.find<AuthRepository>();

  // Animation control
  final RxBool showContent = false.obs;

  bool get canContinue => true;

  void onAnimationsComplete() {
    showContent.value = true;
  }

  Future<void> updateFirstLogin([bool isOrganizationMember = false]) async {
    validating.value = true;
    await authRepository.updateFirstLogin(false, isOrganizationMember);
    validating.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    super.dispose();
  }
}
