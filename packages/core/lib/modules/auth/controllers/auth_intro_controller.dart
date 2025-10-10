import 'dart:async';

import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

enum UserType { artist, organization, member, client }

class AuthIntroController extends GetxController {
  Rx<UserModel?> user = Get.find<BaseAuthController>().user;
  Rx<bool> validating = false.obs;

  final AuthRepository authRepository = Get.find<AuthRepository>();

  // User type selection
  final Rx<UserType?> selectedUserType = Rx<UserType?>(null);

  // Animation control
  final RxBool showContent = false.obs;

  void selectUserType(UserType type) {
    selectedUserType.value = type;
  }

  bool get canContinue => selectedUserType.value != null;

  void onAnimationsComplete() {
    showContent.value = true;
  }

  Future<void> onSelectUserType() async {
    user.value?.isFirstLogin = false;
    user.value?.isOrganizationMember =
        selectedUserType.value == UserType.member;

    await authRepository.setAuthUser(user.value);

    if (selectedUserType.value == UserType.client ||
        selectedUserType.value == UserType.member) {
      // Direct to home for clients and members
      // Update first login status and organization member flag
      await updateFirstLogin(selectedUserType.value == UserType.member);
      Get.offAllNamed(dotenv.env['HOME_ROUTE'] ?? '/home');
    } else if (selectedUserType.value == UserType.artist) {
      Get.offAllNamed(
        dotenv.env['CREATE_PROFILE_ROUTE'] ?? '/home',
        arguments: {'userType': 'artist'},
      );
    } else if (selectedUserType.value == UserType.organization) {
      Get.offAllNamed(
        dotenv.env['CREATE_PROFILE_ROUTE'] ?? '/home',
        arguments: {'userType': 'organization'},
      );
    }
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
