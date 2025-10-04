import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class DescriptionStep extends StatelessWidget {
  final ArtistFormController controller;

  const DescriptionStep({super.key, required this.controller});

  String get _titleText =>
      controller.isArtist.value
          ? 'Cuéntanos más sobre tus habilidades'
          : 'Cuéntanos más sobre tu negocio';

  String get _descriptionText =>
      controller.isArtist.value
          ? 'Cual es tu especialidad.'
          : 'Cual es la especialidad de tu negocio.';

  String get _labelText =>
      controller.isArtist.value ? "Sobre ti" : 'Sobre tu negocio';

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: _titleText,
      descriptionText: _descriptionText,
      focusNode: controller.descriptionFocus,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: CommonTextField(
        hintText: 'Ej: Corte de cabello, Colorimetria, Cejas y Pestañas',
        labelText: _labelText,
        controller: controller.descriptionController,
        focusNode: controller.descriptionFocus,
        maxLines: 4,
      ),
    );
  }
}
