import 'package:flutter/material.dart';
import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class NameStep extends StatelessWidget {
  final ArtistFormController controller;

  const NameStep({super.key, required this.controller});

  String get _introText =>
      controller.isArtist.value
          ? 'Como Artista puedes trabajar de forma independiente, o asociado a una organización.'
          : 'Como Organización puedes administrar varias sedes, cada una con su equipo, horario y servicios.';

  String get _titleText =>
      controller.isArtist.value
          ? '¿Cuál es tu nombre comercial?'
          : '¿Cuál es el nombre de tu organización?';

  String get _descriptionText =>
      controller.isArtist.value
          ? 'El nombre ayudará a tus clientes a identificarte y encontrarte fácilmente.'
          : 'El nombre ayudará a tus clientes a identificar tu organización y encontrarla fácilmente.';

  @override
  Widget build(BuildContext context) {
    // Use controller.isArtist directly to create a new key when the value changes
    Key typingKey = ValueKey(controller.isArtist.value);
    return AnimatedFormStep(
      title: _titleText,
      introText: _introText,
      typingKey: typingKey,
      descriptionText: _descriptionText,
      focusNode: controller.nameFocus,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: CommonTextField(
        labelText: 'Nombre Comercial',
        controller: controller.nameController,
        focusNode: controller.nameFocus,
      ),
    );
  }
}
