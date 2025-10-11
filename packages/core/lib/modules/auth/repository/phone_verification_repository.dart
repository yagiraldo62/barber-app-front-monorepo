import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/providers/phone_verification_provider.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:get/get.dart';

class PhoneVerificationRepository {
  final PhoneVerificationProvider provider =
      Get.find<PhoneVerificationProvider>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  // Backend sends the code on phone set
  Future<bool> setPhoneNumber(String phoneNumber) async {
    return await provider.setPhoneNumber(phoneNumber);
  }

  Future<bool> resendCode() async {
    return await provider.resendCode();
  }

  Future<UserModel?> verifyCode(String code) async {
    final ok = await provider.verifyCode(code);
    if (!ok) return null;
    // Refresh user to fetch updated phone_number_verified_at
    final user = await authRepository.fetchAuthData();
    if (user != null) await authRepository.setAuthUser(user);
    return user;
  }
}
