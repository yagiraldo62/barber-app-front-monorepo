import 'package:core/modules/auth/controllers/phone_verification_controller.dart';
import 'package:core/modules/auth/providers/phone_verification_provider.dart';
import 'package:core/modules/auth/repository/phone_verification_repository.dart';
import 'package:get/get.dart';

class PhoneVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneVerificationProvider>(() => PhoneVerificationProvider());
    Get.lazyPut<PhoneVerificationRepository>(
        () => PhoneVerificationRepository());
    Get.lazyPut<PhoneVerificationController>(
        () => PhoneVerificationController());
  }
}

