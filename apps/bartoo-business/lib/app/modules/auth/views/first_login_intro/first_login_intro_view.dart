import 'package:bartoo/app/modules/auth/controllers/business_auth_intro_controller.dart';
import 'package:bartoo/app/modules/auth/views/first_login_intro/widgets/user_type_selector.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/brand/app_splash.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/button/toggle_theme.dart';
import 'package:ui/widgets/greet/greet.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';
import 'package:ui/widgets/typography/typography.dart';

class FirstLoginIntroView extends StatelessWidget {
  FirstLoginIntroView({super.key});

  final authController = Get.find<BaseAuthController>();

  final BusinessAuthIntroController authIntroController =
      Get.put<BusinessAuthIntroController>(BusinessAuthIntroController());

  // Move the GlobalKey outside of build method to prevent recreation on theme changes
  final welcomeKey = GlobalKey<SequentialTypingMessagesState>();

  @override
  Widget build(BuildContext context) {
    // Remove the guard controller call to prevent infinite loop
    // The guard controller should not be called from the introduction view
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () =>
                    authIntroController.validating.value
                        ? const AppSplash()
                        : Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Greet widget and theme button in the same row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Greet(
                                              name:
                                                  authController
                                                      .user
                                                      .value
                                                      ?.name ??
                                                  '',
                                              onGreetComplete: () {
                                                welcomeKey.currentState
                                                    ?.startAnimation();
                                              },
                                            ),
                                          ),
                                          const ToggleThemeButton(),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Sequential typing messages
                                      SequentialTypingMessages(
                                        key: welcomeKey,
                                        onComplete:
                                            () =>
                                                authIntroController
                                                    .onAnimationsComplete(),
                                        messages: const [
                                          SequentialTypingMessagesItem(
                                            text: '¡Bienvenido a Bartoo!',
                                            variation:
                                                TypographyVariation.titleLarge,
                                            duration: Duration(
                                              milliseconds: 800,
                                            ),
                                          ),
                                          SequentialTypingMessagesItem(
                                            text:
                                                'Selecciona el tipo de usuario que mejor te describe:',
                                            variation:
                                                TypographyVariation.bodyMedium,
                                            duration: Duration(
                                              milliseconds: 800,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Show user type selector after animations
                                      Obx(
                                        () =>
                                            authIntroController
                                                    .showContent
                                                    .value
                                                ? UserTypeSelector(
                                                  selectedType:
                                                      authIntroController
                                                          .selectedUserType,
                                                  onTypeSelected:
                                                      authIntroController
                                                          .selectUserType,
                                                )
                                                : const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Button at the bottom
                            Obx(
                              () =>
                                  authIntroController.showContent.value
                                      ? Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20),
                                        child: AppButton(
                                          onPressed:
                                              authIntroController.canContinue
                                                  ? () {
                                                    if (kDebugMode) {
                                                      print(
                                                        "User type selected: ${authIntroController.selectedUserType.value}",
                                                      );
                                                    }
                                                    authIntroController
                                                        .onSelectUserType();
                                                  }
                                                  : null,
                                          label: "Continuar",
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
