import 'package:bartoo/app/modules/profiles/controllers/forms/profile_form_controller.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/categories_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/description_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/name_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/photo_step.dart';
import 'package:bartoo/app/modules/profiles/widgets/forms/steps/title_step.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';

class ProfileForm extends StatelessWidget {
  final ProfileModel? currentProfile;
  final bool isCreation;
  final ScrollController? scrollController;
  final void Function(ProfileModel)?
  onSaved; // Optional override when creation completes

  const ProfileForm({
    super.key,
    this.currentProfile,
    this.isCreation = false,
    this.scrollController,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(
      ProfileFormController(
        currentProfile,
        isCreation,
        scrollController: scrollController,
        onSavedCallback: onSaved,
      ),
    );

    final controller = Get.find<ProfileFormController>();
    final steps = [
      StepInfo(
        stepWidget: NameStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ProfileFormStep.name.index,
      ),
      StepInfo(
        stepWidget: TitleStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ProfileFormStep.title.index,
      ),
      StepInfo(
        stepWidget: DescriptionStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ProfileFormStep.description.index,
      ),
      StepInfo(
        stepWidget: CategoriesStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ProfileFormStep.categories.index,
      ),
      StepInfo(
        stepWidget: PhotoStep(controller: controller),
        condition:
            () =>
                controller.currentStep.value.index >=
                ProfileFormStep.photo.index,
      ),
    ];

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StepperFormFields<Rx<ProfileFormStep>>(
            controller: controller,
            steps: steps,
            showAllSteps: !isCreation,
            scrollController: scrollController,
            enableAutoScroll: isCreation,
            // showFormCondition: () => showForm,
            showButtonCondition: () => controller.animationsComplete.value,
            isFinalStep: (step) => step == ProfileFormStep.photo,
            buttonLabelBuilder: (step) {
              return step.value == ProfileFormStep.photo
                  ? 'Finalizar'
                  : 'Continuar';
            },
            buttonIconBuilder: (step) {
              return step.value == ProfileFormStep.photo
                  ? Icons.check
                  : Icons.arrow_forward;
            },
          ),
        ],
      ),
    );
  }
}
