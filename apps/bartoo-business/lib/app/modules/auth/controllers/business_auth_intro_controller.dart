import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/modules/auth/controllers/auth_intro_controller.dart';
import 'package:get/route_manager.dart';

/// Business app specific auth intro controller
class BusinessAuthIntroController extends AuthIntroController {
  final Map<UserType, String> userTypeParam = {
    UserType.artist: 'artist',
    UserType.organization: 'organization',
    UserType.member: 'member',
    UserType.client: 'client',
  };

  @override
  Future<void> onSelectUserType() async {
    user.value?.isFirstLogin = false;
    if (selectedUserType.value == UserType.client) {
      updateFirstLogin();
      Get.offAllNamed(Routes.HOME);
    } else if (selectedUserType.value == UserType.artist ||
        selectedUserType.value == UserType.organization) {
      Get.offAllNamed(
        Routes.CREATE_PROFILE,
        arguments: {'userType': userTypeParam[selectedUserType.value]},
      );
    }
  }
}
