import 'package:flutter/material.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/artist_type_selector.dart';

class TypeStep extends StatelessWidget {
  final ArtistFormController controller;

  const TypeStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Qué tipo de cuenta deseas crear?',
      descriptionText:
          'Selecciona la opción que mejor se adapte a tus necesidades.',
      content: ArtistTypeSelector(
        onArtistSelected: () => controller.setType(true),
        onBusinessSelected: () => controller.setType(false),
        typeSelected: controller.typeSelected,
        isArtist: controller.isArtist,
      ),
      // No focus node needed for this step
    );
  }
}
