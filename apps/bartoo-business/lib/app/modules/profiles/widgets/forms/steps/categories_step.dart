import 'package:bartoo/app/modules/profiles/controllers/forms/artist_form_controller.dart';
import 'package:core/data/models/category/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/selectable_entity_button.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class CategoriesStep extends StatelessWidget {
  final ArtistFormController controller;

  const CategoriesStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Selecciona las categorías que mejor te describen',
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
