import 'package:core/modules/auth/controllers/phone_verification_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/input/phone_number_input.dart';
import 'package:ui/widgets/input/otp_code_input.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';
import 'package:ui/widgets/typography/typography.dart';

class PhoneVerificationView extends GetView<PhoneVerificationController> {
  PhoneVerificationView({super.key});

  final scrollController = ScrollController();
  final RxBool showForm = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLayout(
      back: true,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SequentialTypingMessages(
                startImmediately: true,
                onComplete: () => showForm.value = true,
                messages: const [
                  SequentialTypingMessagesItem(
                    text: 'Verifica tu número de teléfono',
                    variation: TypographyVariation.displayLarge,
                    duration: Duration(milliseconds: 800),
                    spacingAfter: 12,
                  ),
                  SequentialTypingMessagesItem(
                    text:
                        'Necesitamos tu número telefónico para proteger tu cuenta y ofrecerte una mejor experiencia.',
                    variation: TypographyVariation.bodyMedium,
                    duration: Duration(milliseconds: 600),
                    spacingAfter: 18,
                  ),
                ],
              ),
              Obx(
                () =>
                    showForm.value
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Phone Number Input Section (hidden after code is sent)
                            Obx(
                              () => AnimatedCrossFade(
                                firstChild: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    PhoneNumberInput(
                                      labelText: 'Número de teléfono',
                                      initialPhone:
                                          controller.phoneController.text,
                                      onChanged: (phoneE164) {
                                        controller.phoneController.text =
                                            phoneE164;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    AppButton(
                                      label: 'Enviar código',
                                      isLoading: controller.isSubmitting.value,
                                      onPressed: controller.submitPhone,
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                                secondChild: const SizedBox.shrink(),
                                crossFadeState:
                                    controller.codeSent.value
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 300),
                              ),
                            ),

                            // OTP Input Section (shown after code is sent)
                            Obx(
                              () => AnimatedCrossFade(
                                firstChild: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Success message
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: theme.colorScheme.primary,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Typography(
                                                  '¡Código enviado!',
                                                  variation:
                                                      TypographyVariation
                                                          .displaySmall,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 4),
                                                Typography(
                                                  'Revisa tu teléfono ${controller.phoneController.text}',
                                                  variation:
                                                      TypographyVariation
                                                          .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // OTP Input Label
                                    Typography(
                                      'Código de verificación',
                                      variation:
                                          TypographyVariation.displaySmall,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 12),

                                    // OTP Input Widget
                                    Center(
                                      child: OtpCodeInput(
                                        length: 6,
                                        onChanged: (value) {
                                          controller.codeController.text =
                                              value;
                                        },
                                        onCompleted: (value) {
                                          controller.codeController.text =
                                              value;
                                          // Auto-submit when OTP is complete
                                          controller.submitCode();
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Verify Button
                                    AppButton(
                                      label: 'Verificar código',
                                      isLoading: controller.isSubmitting.value,
                                      onPressed: controller.submitCode,
                                      width: double.infinity,
                                    ),
                                    const SizedBox(height: 16),

                                    // Resend Code Button
                                    Center(
                                      child: TextButton(
                                        onPressed:
                                            controller.isSubmitting.value
                                                ? null
                                                : controller.resendCode,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              size: 18,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const SizedBox(width: 8),
                                            Typography(
                                              '¿No recibiste el código? Reenviar',
                                              variation:
                                                  TypographyVariation.bodySmall,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Edit Phone Number Link
                                    const SizedBox(height: 8),
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          controller.codeSent.value = false;
                                          controller.codeController.clear();
                                          controller.errorMessage.value = '';
                                        },
                                        child: Typography(
                                          'Cambiar número de teléfono',
                                          variation:
                                              TypographyVariation.bodySmall,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                secondChild: const SizedBox.shrink(),
                                crossFadeState:
                                    controller.codeSent.value
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                duration: const Duration(milliseconds: 300),
                              ),
                            ),

                            // Error Message
                            const SizedBox(height: 16),
                            Obx(
                              () =>
                                  controller.errorMessage.isNotEmpty
                                      ? Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.error
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: theme.colorScheme.error
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: theme.colorScheme.error,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Typography(
                                                controller.errorMessage.value,
                                                color: theme.colorScheme.error,
                                                variation:
                                                    TypographyVariation
                                                        .bodySmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
