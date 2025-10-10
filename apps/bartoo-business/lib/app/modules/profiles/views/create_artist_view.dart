import 'package:bartoo/app/modules/auth/controllers/business_auth_guard_controller.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/greet/greet.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';
import 'package:ui/widgets/typography/typography.dart';

import 'package:bartoo/app/modules/profiles/widgets/forms/artist_form.dart';

class CreateArtistView extends GetView {
  CreateArtistView({super.key});

  final BaseAuthController authController = Get.find<BaseAuthController>();
  final scrollController = ScrollController();
  final welcomeKey = GlobalKey<SequentialTypingMessagesState>();
  final showForm = false.obs;

  @override
  Widget build(BuildContext context) {
    Get.find<BusinessAuthGuardController>();

    return AppLayout(
      back: true,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Greet(
                name: authController.user.value?.name ?? '',
                onGreetComplete: () {
                  welcomeKey.currentState?.startAnimation();
                },
              ),
              const SizedBox(height: 16),

              SequentialTypingMessages(
                key: welcomeKey,
                onComplete: () => showForm.value = true,
                messages: const [
                  SequentialTypingMessagesItem(
                    text: 'Te damos la bienvenida',
                    variation: TypographyVariation.titleLarge,
                    duration: Duration(milliseconds: 800),
                  ),
                ],
              ),
              Obx(
                () => ProfileForm(
                  isCreation: true,
                  scrollController: scrollController,
                  showForm: showForm.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
