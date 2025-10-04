import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/categories_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/description_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/name_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/photo_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/title_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';

import 'package:core/data/models/artists/artist_model.dart';

class ArtistForm extends StatelessWidget {
  final ArtistModel? currentArtist;
  final bool isCreation;
  final ScrollController? scrollController;
  final bool showForm;

  const ArtistForm({
    super.key,
    this.currentArtist,
    this.isCreation = false,
    this.scrollController,
    this.showForm = false,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(ArtistFormController(currentArtist, isCreation));

    final controller = Get.find<ArtistFormController>();
    final steps = [
      StepInfo(
        stepWidget: NameStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >= ArtistFormStep.name.index,
      ),
      StepInfo(
        stepWidget: TitleStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ArtistFormStep.title.index,
      ),
      StepInfo(
        stepWidget: DescriptionStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ArtistFormStep.description.index,
      ),
      StepInfo(
        stepWidget: CategoriesStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ArtistFormStep.categories.index,
      ),
      StepInfo(
        stepWidget: PhotoStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ArtistFormStep.photo.index,
      ),
    ];

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (controller.isCreation)
            StepperFormFields<Rx<ArtistFormStep>>(
              controller: controller,
              steps: steps,
              scrollController: scrollController,
              showFormCondition: () => showForm,
              showButtonCondition: () => controller.animationsComplete.value,
              isFinalStep: (step) => step == ArtistFormStep.photo,
              buttonLabelBuilder: (step) {
                return step.value == ArtistFormStep.photo
                    ? 'Finalizar'
                    : 'Continuar';
              },
              buttonIconBuilder: (step) {
                return step.value == ArtistFormStep.photo
                    ? Icons.check
                    : Icons.arrow_forward;
              },
            ),
        ],
      ),
    );
  }
}
