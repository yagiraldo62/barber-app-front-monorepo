import 'package:bartoo/app/modules/profiles/controllers/forms/profile_form_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class TitleStep extends StatelessWidget {
  final ProfileFormController controller;

  const TitleStep({super.key, required this.controller});

  String get _titleText =>
      controller.profileType.value == ProfileType.artist
          ? '¿Cuál es tu título profesional?'
          : '¿Qué tipo de negocio tienes?';

  String get _hintText =>
      controller.profileType.value == ProfileType.artist
          ? 'Ej: Barbero profesional, Estilista, etc.'
          : 'Ej: Barbería, Spa, Peluquería, etc.';
  String get _labelText =>
      controller.profileType.value == ProfileType.artist
          ? 'Título'
          : 'Tipo de negocio';

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
