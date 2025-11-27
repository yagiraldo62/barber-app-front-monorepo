import 'package:bartoo/app/profiles/controllers/forms/profile_form_controller.dart';
import 'package:core/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/selectable_entity_button.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class CategoriesStep extends StatelessWidget {
  final ProfileFormController controller;

  const CategoriesStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Selecciona las categorías que mejor te describen',
      scrollToBottom: controller.scrollToBottom,
      noAnimation: !controller.isCreation,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Obx(
        () => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectableEntityButtonList<CategoryModel>(
            controller.categories.value,
            controller.setCategories,
          ),
        ),
      ),
    );
  }
}
