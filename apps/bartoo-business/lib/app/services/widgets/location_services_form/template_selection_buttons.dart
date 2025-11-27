import 'package:flutter/material.dart';
import 'package:ui/widgets/template/template_selector.dart';
import 'package:core/data/models/services_template_model.dart';

class TemplateSelectionButtons extends StatelessWidget {
  const TemplateSelectionButtons({
    super.key,
    required this.templates,
    required this.selectedTemplateIds,
    required this.onTemplateToggle,
  });

  final List<ServicesTemplateModel> templates;
  final List<String> selectedTemplateIds;
  final void Function(String templateId) onTemplateToggle;

  @override
  Widget build(BuildContext context) {
    return TemplateSelector<ServicesTemplateModel>(
      templates: templates,
      isSelected: (template) => selectedTemplateIds.contains(template.id),
      onTemplateToggle: (template) => onTemplateToggle(template.id),
      getTemplateName: (template) => template.name,
      emptyMessage: 'No hay plantillas para las categorías seleccionadas',
    );
  }
}
