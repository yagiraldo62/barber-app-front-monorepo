import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';
import 'package:ui/widgets/typography/typography.dart';

import 'package:bartoo/app/modules/locations/widgets/forms/location_form.dart';
import 'package:utils/log.dart';

class CreateLocationView extends StatelessWidget {
  const CreateLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    Log('CreateLocationView');
    final scrollController = ScrollController();
    final welcomeKey = GlobalKey<SequentialTypingMessagesState>();
    final showForm = false.obs;

    return AppLayout(
      back: true,
      // title: "Nueva ubicación",
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SequentialTypingMessages(
                key: welcomeKey,
                onComplete: () => showForm.value = true,
                startImmediately: true,
                messages: const [
                  SequentialTypingMessagesItem(
                    text: 'Registra una nueva ubicación',
                    variation: TypographyVariation.displayLarge,
                    duration: Duration(milliseconds: 800),
                    spacingAfter: 14,
                  ),
                ],
              ),
              Obx(
                () => LocationForm(
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
