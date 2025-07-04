import 'package:base/providers/base_provider.dart';
import 'package:utils/log.dart';
import 'package:core/data/models/user/user_model.dart';

class AuthProvider extends BaseProvider {
  Future<UserModel?> getAuthInfo() async {
    final response = await get('/auth');

    Log("User From DB", [response.body]);

    if (response.body?["ok"] == true) {
      return UserModel.fromJson(response.body["data"]);
    }

    return null;
  }

  Future<bool> updateFirstLogin(bool isFirstLogin) async {
    final response = await post('/auth/first-login', {
      'is_first_login': isFirstLogin,
    });

    if (response.body?["ok"] == true) {
      return true;
    }

    return false;
  }
}
