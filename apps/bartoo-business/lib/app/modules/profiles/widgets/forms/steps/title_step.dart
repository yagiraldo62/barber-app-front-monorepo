import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class TitleStep extends StatelessWidget {
  final ArtistFormController controller;

  const TitleStep({super.key, required this.controller});

  String get _titleText =>
      controller.isArtist.value
          ? '¿Cuál es tu título profesional?'
          : '¿Qué tipo de negocio tienes?';

  String get _hintText =>
      controller.isArtist.value
          ? 'Ej: Barbero profesional, Estilista, etc.'
          : 'Ej: Barbería, Spa, Peluquería, etc.';

  String get _descriptionText =>
      controller.isArtist.value
          ? 'Este título ayudará a tus clientes a identificarte y a encontrar tus servicios más fácilmente.'
          : 'Este título ayudará a tus clientes a identificar tu negocio y a encontrar tus servicios más fácilmente.';

  String get _labelText =>
      controller.isArtist.value ? 'Título' : 'Tipo de negocio';

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: _titleText,
      focusNode: controller.titleFocus,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: CommonTextField(
        hintText: _hintText,
        labelText: _labelText,
        controller: controller.titleController,
        focusNode: controller.titleFocus,
      ),
    );
  }
}
