import 'package:bartoo/app/modules/profiles/controllers/forms/profile_form_controller.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/input/avatar_picker.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class PhotoStep extends StatelessWidget {
  final ProfileFormController controller;

  const PhotoStep({super.key, required this.controller});

  String get _photoMessage {
    return controller.profileType.value == ProfileType.artist
        ? 'Elijir una buena foto puede hacer que destaques en la seccion de busqueda.'
        : 'Añade el logo de tu negocio, esto puedes hacerlo después si prefieres';
  }

  @override
  Widget build(BuildContext context) {
    // Use controller.isArtist directly to create a new key when the value changes
    Key typingKey = ValueKey(controller.profileType.value);
    return AnimatedFormStep(
      title: _photoMessage,
      typingKey: typingKey,
      onAnimationsComplete: controller.onAnimationsComplete,
      contentPadding: EdgeInsets.zero, // No padding for centered content
      content: Center(
        child: AvatarPicker(
          onPickImage: (image) => controller.setImage(image),
          imageUrl: controller.currentProfile?.photoUrl,
        ),
      ),
    );
  }
}
