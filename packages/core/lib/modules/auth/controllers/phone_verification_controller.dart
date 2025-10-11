import 'package:core/data/models/user_model.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:core/modules/auth/repository/phone_verification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class PhoneVerificationController extends GetxController {
  final PhoneVerificationRepository repository =
      Get.find<PhoneVerificationRepository>();
  final Rx<UserModel?> user = Get.find<BaseAuthController>().user;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool codeSent = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isPhoneVerified => user.value?.isPhoneVerified == true;

  @override
  void onInit() {
    super.onInit();
    phoneController.text = user.value?.phoneNumber ?? '';
  }

  Future<void> submitPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      errorMessage.value = 'Por favor ingresa tu número telefónico';
      return;
    }
    errorMessage.value = '';
    isSubmitting.value = true;
    try {
      final sent = await repository.setPhoneNumber(phone);
      codeSent.value = sent;
      if (!sent) {
        errorMessage.value = 'No se pudo enviar el código. Intenta de nuevo.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> resendCode() async {
    isSubmitting.value = true;
    try {
      final sent = await repository.resendCode();
      codeSent.value = sent || codeSent.value;
      if (!sent) {
        errorMessage.value = 'No se pudo reenviar el código.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submitCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      errorMessage.value = 'Ingresa el código de verificación';
      return;
    }
    errorMessage.value = '';
    isSubmitting.value = true;
    try {
      final updatedUser = await repository.verifyCode(code);
      if (updatedUser?.isPhoneVerified == true) {
        Get.find<BaseAuthController>().setUser(updatedUser!);
        // timeout to allow UI to update
        await Future.delayed(const Duration(milliseconds: 2000));
        // After verification, redirect to splash (guard performs redirection)
        final splashRoute = dotenv.env['SPLASH_ROUTE'] ?? '/';
        Get.offAllNamed(splashRoute);
      } else {
        errorMessage.value = 'Código inválido. Revisa e intenta nuevamente.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
