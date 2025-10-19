# Template Selector Widget

## Overview

The `TemplateSelector` is a generic, reusable widget for displaying and selecting templates across the application. It provides a consistent UI for template selection with support for both single and multiple selection modes.

## Location

`packages/ui/lib/widgets/template/template_selector.dart`

## Features

- ✅ **Generic Type Support**: Works with any template type using Dart generics
- ✅ **Flexible Selection**: Supports both single and multiple selection modes
- ✅ **Customizable Display**: Custom functions to extract template name and optional subtitle
- ✅ **Empty State**: Configurable message when no templates are available
- ✅ **Consistent UI**: Uses `SelectableButton` for uniform appearance
- ✅ **Typography Integration**: Uses `Typography` widget for text consistency
- ✅ **Responsive Layout**: Uses `Wrap` for automatic grid layout

## Usage

### Basic Example (Single Selection)

```dart
TemplateSelector<AvailabilityTemplateModel>(
  templates: availabilityTemplates,
  isSelected: (template) => selectedTemplateId == template.id,
  onTemplateToggle: (template) {
    selectedTemplateId = template.id;
  },
  getTemplateName: (template) => template.name,
  emptyMessage: 'No hay plantillas de disponibilidad disponibles',
)
```

### Multiple Selection Example

```dart
TemplateSelector<ServicesTemplateModel>(
  templates: serviceTemplates,
  isSelected: (template) => selectedTemplateIds.contains(template.id),
  onTemplateToggle: (template) {
    if (selectedTemplateIds.contains(template.id)) {
      selectedTemplateIds.remove(template.id);
    } else {
      selectedTemplateIds.add(template.id);
    }
  },
  getTemplateName: (template) => template.name,
  emptyMessage: 'No hay plantillas para las categorías seleccionadas',
)
```

### With Subtitle

```dart
TemplateSelector<ServicesTemplateModel>(
  templates: serviceTemplates,
  isSelected: (template) => selectedTemplateIds.contains(template.id),
  onTemplateToggle: (template) => toggleTemplate(template.id),
  getTemplateName: (template) => template.name,
  getTemplateSubtitle: (template) => template.category?.name,
  emptyMessage: 'No templates available',
  spacing: 12.0,  // Custom spacing
  runSpacing: 12.0,  // Custom run spacing
)
```

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `templates` | `List<T>` | List of template objects to display |
| `isSelected` | `bool Function(T)` | Function to determine if a template is selected |
| `onTemplateToggle` | `void Function(T)` | Callback when a template is tapped |
| `getTemplateName` | `String Function(T)` | Function to extract the template name for display |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `getTemplateSubtitle` | `String? Function(T)?` | `null` | Optional function to extract a subtitle |
| `emptyMessage` | `String` | `'No templates available'` | Message shown when list is empty |
| `spacing` | `double` | `8.0` | Horizontal spacing between buttons |
| `runSpacing` | `double` | `8.0` | Vertical spacing between button rows |

## Current Implementations

### 1. Availability Templates
**File**: `apps/bartoo-business/lib/app/modules/availability/widgets/availability_form/steps/template_selection_step.dart`

```dart
TemplateSelector<AvailabilityTemplateModel>(
  templates: templates,
  isSelected: (template) => controller.selectedTemplateId.value == template.id,
  onTemplateToggle: (template) {
    controller.selectedTemplateId.value = template.id;
  },
  getTemplateName: (template) => template.name,
  emptyMessage: 'No hay plantillas de disponibilidad disponibles',
)
```

**Selection Mode**: Single selection
**Use Case**: Selecting availability schedule template

### 2. Services Templates
**File**: `apps/bartoo-business/lib/app/modules/services/widgets/location_services_form/template_selection_buttons.dart`

```dart
TemplateSelector<ServicesTemplateModel>(
  templates: templates,
  isSelected: (template) => selectedTemplateIds.contains(template.id),
  onTemplateToggle: (template) => onTemplateToggle(template.id),
  getTemplateName: (template) => template.name,
  emptyMessage: 'No hay plantillas para las categorías seleccionadas',
)
```

**Selection Mode**: Multiple selection
**Use Case**: Selecting multiple service templates to apply

## Benefits

### Code Reusability
- **Before**: Each template selection screen had duplicate UI code
- **After**: Single widget used across availability and services modules

### Consistency
- All template selections look and behave the same way
- Automatic color inheritance from `SelectableButton`
- Uniform typography and spacing

### Maintainability
- Changes to template selection UI only need to be made in one place
- Type-safe generic implementation prevents errors
- Easy to add new template types

### Flexibility
- Works with any model that has a name property
- Supports optional subtitle for additional context
- Configurable spacing and messages

## Type Safety

The widget uses Dart generics to ensure type safety:

```dart
class TemplateSelector<T> extends StatelessWidget {
  // T can be any type: AvailabilityTemplateModel, ServicesTemplateModel, etc.
}
```

This means:
- Compile-time type checking
- No runtime type errors
- IntelliSense support in IDEs
- Refactoring safety

## Future Enhancements

Potential improvements:
1. Add filtering/search functionality
2. Add sorting options
3. Support for template icons
4. Support for template badges (new, popular, etc.)
5. Grid vs List layout toggle
6. Template preview on long press
7. Drag and drop for reordering in multiple selection mode
