import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';

import 'package:core/data/models/availability_template_model.dart';
import 'package:ui/widgets/button/app_text_button.dart';
import 'package:ui/widgets/template/template_selector.dart';
import 'package:ui/widgets/typography/typography.dart';
import '../availability_form_controller.dart';

class TemplateSelectionStep extends StatelessWidget {
  TemplateSelectionStep({super.key, required this.controller});

  final AvailabilityFormController controller;
  final RxBool showTemplates = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If existing availability, allow switching templates but show hint
      final hasExisting = controller.hasExistingAvailability;
      final templates = controller.templates;
      // Capture selectedTemplateId to ensure Obx tracks it
      final selectedId = controller.selectedTemplateId.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasExisting) ...[
            AppTextButton(
              onPressed: () => showTemplates.value = !showTemplates.value,
              icon: Icon(
                showTemplates.value ? Icons.visibility_off : Icons.visibility,
              ),
              label:
                  showTemplates.value
                      ? 'Ocultar plantillas'
                      : 'Mostrar plantillas',
              variation: TypographyVariation.headlineSmall,
            ),
          ],
          if (!hasExisting || showTemplates.value) ...[
            if (!hasExisting) ...[
              Typography(
                'Plantillas disponibles',
                variation: TypographyVariation.headlineMedium,
              ),
              const SizedBox(height: 8),
            ],
            TemplateSelector<AvailabilityTemplateModel>(
              templates: templates,
              isSelected: (template) => selectedId == template.id,
              onTemplateToggle: (template) {
                controller.setEditableFromTemplate(template);
              },
              getTemplateName: (template) => template.name,
              emptyMessage: 'No hay plantillas de disponibilidad disponibles',
            ),
            const SizedBox(height: 16),
            if (hasExisting && selectedId.isNotEmpty) ...[
              AppTextButton(
                onPressed: () {
                  controller.cancelTemplateSelection();
                  showTemplates.value = false;
                },
                icon: const Icon(Icons.cancel_outlined),
                label: 'Cancelar y restaurar disponibilidad existente',
                variation: TypographyVariation.headlineSmall,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      );
    });
  }
}
