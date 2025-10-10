import 'package:core/modules/auth/providers/auth_provider.dart';
import 'package:core/modules/auth/repository/auth_storage_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:utils/web/launch_uri.dart';
import 'package:core/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AuthRepository extends AuthStorageRepository {
  final UserRepository userRepository = Get.find<UserRepository>();
  final AuthProvider authProvider = Get.find<AuthProvider>();

  AuthRepository();

  Future<UserModel?> fetchAuthData() async {
    UserModel? userModel = await authProvider.getAuthInfo();
    return userModel;
  }

  void signInWithFacebook() async {
    final apiUrl = dotenv.env['API_URL'] ?? '';
    launchUri('$apiUrl/auth/facebook');
  }

  void signout() async {
    await setSelectedScope(null);
    await setAuthUser(null);
    await setAuthToken(null);
  }

  Future<void> updateFirstLogin([
    bool isFirstLogin = false,
    bool isOrganizationMember = false,
  ]) async {
    await authProvider.updateFirstLogin(
      isFirstLogin: isFirstLogin,
      isOrganizationMember: isOrganizationMember,
    );
  }
}
