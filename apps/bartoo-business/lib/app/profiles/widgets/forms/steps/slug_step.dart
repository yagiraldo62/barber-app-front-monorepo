import 'package:bartoo/app/profiles/controllers/forms/profile_form_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';
import 'package:ui/widgets/typography/typography.dart';

class SlugStep extends StatelessWidget {
  final ProfileFormController controller;

  const SlugStep({super.key, required this.controller});

  String get _titleText => 'Crea el identificador de tu perfil (Slug)';

  String get _descriptionText =>
      'El slug es un identificador único basado en tu nombre que se usa en la URL de tu perfil. '
      'Se genera automáticamente, pero puedes personalizarlo.';

  @override
  Widget build(BuildContext context) {
    Key typingKey = ValueKey(controller.profileType.value);
    return AnimatedFormStep(
      title: _titleText,
      scrollToBottom: controller.scrollToBottom,
      noAnimation: !controller.isCreation,
      typingKey: typingKey,
      descriptionText: _descriptionText,
      focusNode: controller.slugFocus,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: CommonTextField(
        labelText: 'Identificador de Perfil (Slug)',
        hintText: 'jon.barber.45',
        controller: controller.slugController,
        focusNode: controller.slugFocus,
        textStyle: Theme.of(context).textTheme.displayMedium,
        prefixIcon: Typography(
          '@',
          variation: TypographyVariation.headlineLarge,
        ),
        onChanged: (value) {
          // Filter out invalid characters (keep only alphanumeric, dots, and hyphens)
          final filtered = value.replaceAll(RegExp(r'[^a-zA-Z0-9.\-]'), '');
          if (filtered != value) {
            controller.slugController.text = filtered;
            controller.slugController.selection = TextSelection.fromPosition(
              TextPosition(offset: filtered.length),
            );
          }
        },
      ),
    );
  }
}
