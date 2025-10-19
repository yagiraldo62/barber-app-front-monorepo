import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/button/selectable_button.dart';
import 'package:ui/widgets/typography/typography.dart';

/// A generic reusable widget for selecting templates
///
/// This widget displays a list of templates as selectable buttons
/// and supports both single and multiple selection modes.
class TemplateSelector<T> extends StatelessWidget {
  const TemplateSelector({
    super.key,
    required this.templates,
    required this.isSelected,
    required this.onTemplateToggle,
    required this.getTemplateName,
    this.emptyMessage = 'No templates available',
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  /// List of templates to display
  final List<T> templates;

  /// Function to determine if a template is selected
  final bool Function(T template) isSelected;

  /// Callback when a template is tapped
  final void Function(T template) onTemplateToggle;

  /// Function to extract the template name for display
  final String Function(T template) getTemplateName;

  /// Message to display when no templates are available
  final String emptyMessage;

  /// Horizontal spacing between template buttons
  final double spacing;

  /// Vertical spacing between template button rows
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return Text(
        emptyMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children:
          templates
              .map(
                (template) => SelectableButton(
                  selected: isSelected(template),
                  onSelectionChange: () => onTemplateToggle(template),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      getTemplateName(template),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
