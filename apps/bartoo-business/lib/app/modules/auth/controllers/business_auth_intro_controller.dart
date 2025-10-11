import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/modules/auth/controllers/base_auth_intro_controller.dart';
import 'package:get/route_manager.dart';

/// Business app specific auth intro controller
class BusinessAuthIntroController extends BaseAuthIntroController {
  final Map<UserType, String> userTypeParam = {
    UserType.artist: 'artist',
    UserType.organization: 'organization',
    UserType.member: 'member',
    UserType.client: 'client',
  };

  @override
  Future<void> onSelectUserType() async {
    if (selectedUserType.value == UserType.client ||
        selectedUserType.value == UserType.member) {
      updateFirstLogin(selectedUserType.value == UserType.member);
      Get.offAllNamed(Routes.HOME);

      user.value?.isFirstLogin = false;
      user.value?.isOrganizationMember =
          selectedUserType.value == UserType.member;

      await authRepository.setAuthUser(user.value);
    } else if (selectedUserType.value == UserType.artist ||
        selectedUserType.value == UserType.organization) {
      Get.offAllNamed(
        Routes.CREATE_PROFILE,
        arguments: {'userType': userTypeParam[selectedUserType.value]},
      );
    }
  }
}
