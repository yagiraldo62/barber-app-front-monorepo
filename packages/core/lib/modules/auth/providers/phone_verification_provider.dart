import 'package:base/providers/base_provider.dart';

class PhoneVerificationProvider extends BaseProvider {
  // PUT auth/phone-number
  Future<bool> setPhoneNumber(String phoneNumber) async {
    final response = await put('/auth/phone-number', {
      'phone_number': phoneNumber,
    });
    return response.body?["ok"] == true;
  }

  // POST auth/resend-phone-number-code
  Future<bool> resendCode() async {
    final response = await post('/auth/resend-phone-number-code', {});
    return response.body?["ok"] == true;
  }

  // POST auth/verify-phone-number
  Future<bool> verifyCode(String code) async {
    final response = await post('/auth/verify-phone-number', {
      'verification_code': code,
    });
    return response.body?["ok"] == true;
  }
}
