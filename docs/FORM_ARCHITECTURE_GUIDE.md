# Form Architecture Guide

## Overview

This document describes the standardized architecture for creating reusable, step-based forms in the Bartoo application. The forms follow a consistent pattern that enables them to be used in multiple contexts, such as standalone pages or integrated into multi-step flows like the Setup Scope Flow.

---

## Table of Contents

1. [Architecture Components](#architecture-components)
2. [Core Concepts](#core-concepts)
3. [Standard Form Structure](#standard-form-structure)
4. [Controller Implementation](#controller-implementation)
5. [Step Widgets](#step-widgets)
6. [Integration Patterns](#integration-patterns)
7. [Creating New Forms](#creating-new-forms)
8. [Best Practices](#best-practices)

---

## Architecture Components

### 1. **StepperFormFields Widget** (`packages/ui/lib/widgets/form/stepper_form_fields.dart`)

A generic, reusable widget that handles the rendering and navigation logic for step-based forms.

**Key Features:**
- Progressive step revelation based on conditions
- Support for "show all steps" mode (edit mode)
- Automatic scroll management
- Customizable button labels and icons
- Animation support
- Loading state handling

**Key Properties:**
```dart
StepperFormFields<T>({
  required StepperFormController<T> controller,
  required List<StepInfo> steps,
  required bool Function(T step) isFinalStep,
  bool showAllSteps = false,              // Edit vs Create mode
  ScrollController? scrollController,      // Auto-scroll support
  bool enableAutoScroll = true,
  String Function(T step)? buttonLabelBuilder,
  IconData Function(T step)? buttonIconBuilder,
  bool Function()? showButtonCondition,
  // ... other customization options
})
```

### 2. **StepperFormController Interface**

An abstract interface that form controllers must implement:

```dart
abstract class StepperFormController<T> {
  T get currentStep;           // Current step state
  bool get isLoading;          // Loading state
  void nextStep();             // Navigation handler
}
```

### 3. **StepInfo Class**

Encapsulates individual step information:

```dart
class StepInfo {
  final Widget stepWidget;              // The step's UI
  final bool Function()? condition;     // When to show this step
}
```

---

## Core Concepts

### Progressive Disclosure Pattern

Forms use a **progressive disclosure pattern** where steps are revealed one at a time during creation:

1. **Creation Mode** (`isCreation = true`):
   - Steps appear progressively as user completes previous steps
   - Only current and completed steps are visible
   - Auto-scrolls to show action button
   - Provides focused, guided experience

2. **Edit Mode** (`isCreation = false`):
   - All steps shown at once (`showAllSteps = true`)
   - User can edit any field
   - No progressive revelation
   - No auto-scrolling

### State Management

All forms use **GetX** for reactive state management:
- Controllers extend `GetxController`
- Reactive variables use `.obs` suffix
- UI updates automatically via `Obx()` widgets

### Callback Pattern

Forms support callback functions to notify parent widgets of completion:

```dart
final void Function(ModelType)? onSaved;
```

This enables:
- Integration into multi-step flows
- Custom post-save actions
- Flexible composition patterns

---

## Standard Form Structure

### File Organization

```
app/modules/{module}/
  ├── controllers/
  │   └── forms/
  │       └── {entity}_form_controller.dart
  ├── widgets/
  │   └── forms/
  │       ├── {entity}_form.dart           # Main form widget
  │       └── steps/
  │           ├── step_one.dart
  │           ├── step_two.dart
  │           └── step_three.dart
```

### Form Widget Template

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';

class EntityForm extends StatelessWidget {
  final EntityModel? currentEntity;
  final bool isCreation;
  final ScrollController? scrollController;
  final void Function(EntityModel)? onSaved;

  const EntityForm({
    super.key,
    this.currentEntity,
    this.isCreation = true,
    this.scrollController,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller (if not already registered)
    if (!Get.isRegistered<EntityFormController>()) {
      Get.put(
        EntityFormController(
          currentEntity: currentEntity,
          isCreation: isCreation,
          onSavedCallback: onSaved,
          scrollController: scrollController,
        ),
      );
    }

    final controller = Get.find<EntityFormController>();

    // Define steps
    final steps = [
      StepInfo(
        stepWidget: StepOne(controller: controller),
        condition: () => controller.currentStep.value.index >= EntityFormStep.stepOne.index,
      ),
      StepInfo(
        stepWidget: StepTwo(controller: controller),
        condition: () => controller.currentStep.value.index >= EntityFormStep.stepTwo.index,
      ),
      // ... more steps
    ];

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepperFormFields<Rx<EntityFormStep>>(
            controller: controller,
            steps: steps,
            showAllSteps: !isCreation,
            scrollController: scrollController,
            enableAutoScroll: isCreation,
            showButtonCondition: () => controller.animationsComplete.value,
            isFinalStep: (step) => step.value == EntityFormStep.lastStep,
            buttonLabelBuilder: (step) {
              return step.value == EntityFormStep.lastStep
                  ? 'Finalizar'
                  : 'Continuar';
            },
            buttonIconBuilder: (step) {
              return step.value == EntityFormStep.lastStep
                  ? Icons.check
                  : Icons.arrow_forward;
            },
          ),
        ],
      ),
    );
  }
}
```

---

## Controller Implementation

### Step Enum

Define an enum to represent form steps:

```dart
enum EntityFormStep { stepOne, stepTwo, stepThree, stepFour }
```

### Controller Template

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';

class EntityFormController extends GetxController
    implements StepperFormController<Rx<EntityFormStep>> {
  
  // Constructor parameters
  final EntityModel? currentEntity;
  final bool isCreation;
  final void Function(EntityModel)? onSavedCallback;
  final ScrollController? scrollController;

  EntityFormController({
    this.currentEntity,
    this.isCreation = true,
    this.onSavedCallback,
    this.scrollController,
  });

  // Repositories and dependencies
  final EntityRepository repository = Get.find<EntityRepository>();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Focus nodes
  final nameFocus = FocusNode();
  final descriptionFocus = FocusNode();

  // Reactive state
  final loading = false.obs;
  final animationsComplete = false.obs;

  // Required by StepperFormController interface
  @override
  final currentStep = Rx<EntityFormStep>(EntityFormStep.stepOne);

  @override
  bool get isLoading => loading.value;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize animation state
    animationsComplete.value = false;

    // Populate fields if editing
    if (currentEntity != null) {
      nameController.text = currentEntity!.name;
      descriptionController.text = currentEntity!.description ?? '';
      currentStep.value = EntityFormStep.stepOne;
    }

    // Load initial data
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load any required data
  }

  @override
  void nextStep() {
    if (isLoading) return;

    switch (currentStep.value) {
      case EntityFormStep.stepOne:
        if (_validateStepOne()) {
          _moveToStep(EntityFormStep.stepTwo);
        }
        break;
      case EntityFormStep.stepTwo:
        if (_validateStepTwo()) {
          _moveToStep(EntityFormStep.stepThree);
        }
        break;
      // ... handle other steps
      case EntityFormStep.lastStep:
        _submitForm();
        break;
    }
  }

  void _moveToStep(EntityFormStep step) {
    currentStep.value = step;
    // Add delay for animation
    Future.delayed(const Duration(milliseconds: 100), () {
      animationsComplete.value = true;
    });
  }

  bool _validateStepOne() {
    if (nameController.text.trim().isEmpty) {
      // Show error
      return false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    try {
      loading.value = true;

      // Build model
      final entity = EntityModel(
        id: currentEntity?.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
      );

      // Save via repository
      final saved = isCreation
          ? await repository.create(entity)
          : await repository.update(entity);

      if (saved != null) {
        // Notify parent via callback
        onSavedCallback?.call(saved);
        
        // Or navigate
        // Get.back(result: saved);
      }
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    // Cleanup
    nameController.dispose();
    descriptionController.dispose();
    nameFocus.dispose();
    descriptionFocus.dispose();
    super.onClose();
  }
}
```

### Key Controller Requirements

1. **Implement `StepperFormController<Rx<EnumType>>`**
2. **Provide `currentStep`, `isLoading`, and `nextStep()`**
3. **Manage `animationsComplete` flag** for smooth UI transitions
4. **Handle both creation and edit modes**
5. **Support callback pattern** via `onSavedCallback`
6. **Properly cleanup** resources in `onClose()`

---

## Step Widgets

### Step Widget Template

Each step should be a separate, focused widget:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepOne extends StatelessWidget {
  final EntityFormController controller;

  const StepOne({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.nameController,
          focusNode: controller.nameFocus,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter name',
          ),
          onFieldSubmitted: (_) => controller.nextStep(),
        ),
      ],
    );
  }
}
```

### Step Design Principles

1. **Single Responsibility**: Each step handles one concept
2. **Self-Contained**: Step includes its own title and instructions
3. **Controller Reference**: Access shared state via controller
4. **Submit on Enter**: Support `onFieldSubmitted` for better UX
5. **Validation Feedback**: Show inline errors when appropriate

---

## Integration Patterns

### Pattern 1: Standalone Usage

Use form directly in a route or page:

```dart
class EntityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Entity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EntityForm(
          isCreation: true,
          onSaved: (entity) {
            // Handle completion
            Get.back(result: entity);
          },
        ),
      ),
    );
  }
}
```

### Pattern 2: Multi-Step Flow Integration

Integrate form into a larger flow (like `SetupScopeFlow`):

```dart
FlowStepConfig(
  step: CreateProfileStep.entity,
  title: 'Entity',
  stepTitle: 'Configure Entity',
  svgAsset: "assets/images/svgs/entity.svg",
  build: () => EntityForm(
    currentEntity: controller.currentEntity.value,
    isCreation: controller.currentEntity.value?.id == null,
    scrollController: scrollController,
    onSaved: (entity) => controller.onEntitySaved(entity),
  ),
)
```

### Pattern 3: Nested Forms

Some forms (like `LocationServicesForm`) manage internal state differently:

```dart
class LocationServicesForm extends StatefulWidget {
  final String profileId;
  final String locationId;
  final bool servicesUp;
  final void Function(bool success)? onSaved;

  // Uses StatefulWidget + internal controller
  // Not step-based, but follows callback pattern
}
```

**When to use this pattern:**
- Form has complex internal navigation
- Multiple sub-components with their own state
- Not strictly linear progression

---

## Creating New Forms

### Checklist for New Step-Based Forms

1. **Define Step Enum**
   ```dart
   enum MyFormStep { stepOne, stepTwo, stepThree }
   ```

2. **Create Controller**
   - Extend `GetxController`
   - Implement `StepperFormController<Rx<MyFormStep>>`
   - Add required properties and methods
   - Implement validation and submission logic

3. **Create Step Widgets**
   - One widget per step
   - Place in `steps/` subdirectory
   - Keep focused and self-contained

4. **Create Form Widget**
   - Use template structure
   - Configure `StepperFormFields` properly
   - Support both creation and edit modes

5. **Support Required Parameters**
   ```dart
   final ModelType? currentModel;
   final bool isCreation;
   final ScrollController? scrollController;
   final void Function(ModelType)? onSaved;
   ```

6. **Handle Animation State**
   ```dart
   final animationsComplete = false.obs;
   
   void _moveToNextStep() {
     currentStep.value = NextStep;
     Future.delayed(Duration(milliseconds: 100), () {
       animationsComplete.value = true;
     });
   }
   ```

7. **Implement Cleanup**
   ```dart
   @override
   void onClose() {
     // Dispose controllers, focus nodes, etc.
     super.onClose();
   }
   ```

### Example: Creating an Availability Form

Following the established pattern:

```dart
// 1. Define enum
enum AvailabilityFormStep { template, customize, review }

// 2. Create controller
class AvailabilityFormController extends GetxController
    implements StepperFormController<Rx<AvailabilityFormStep>> {
  
  final AvailabilityModel? currentAvailability;
  final bool isCreation;
  final void Function(AvailabilityModel)? onSavedCallback;
  final ScrollController? scrollController;

  AvailabilityFormController({
    this.currentAvailability,
    this.isCreation = true,
    this.onSavedCallback,
    this.scrollController,
  });

  @override
  final currentStep = Rx<AvailabilityFormStep>(AvailabilityFormStep.template);
  
  final loading = false.obs;
  final animationsComplete = false.obs;

  @override
  bool get isLoading => loading.value;

  @override
  void nextStep() {
    // Implementation
  }
}

// 3. Create step widgets
class TemplateSelectionStep extends StatelessWidget {
  final AvailabilityFormController controller;
  const TemplateSelectionStep({required this.controller});
  
  @override
  Widget build(BuildContext context) {
    // Step UI
  }
}

// 4. Create form widget
class AvailabilityForm extends StatelessWidget {
  final AvailabilityModel? currentAvailability;
  final bool isCreation;
  final ScrollController? scrollController;
  final void Function(AvailabilityModel)? onSaved;

  const AvailabilityForm({
    this.currentAvailability,
    this.isCreation = true,
    this.scrollController,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(AvailabilityFormController(
      currentAvailability: currentAvailability,
      isCreation: isCreation,
      onSavedCallback: onSaved,
      scrollController: scrollController,
    ));

    final controller = Get.find<AvailabilityFormController>();
    
    final steps = [
      StepInfo(
        stepWidget: TemplateSelectionStep(controller: controller),
        condition: () => controller.currentStep.value.index >= 
            AvailabilityFormStep.template.index,
      ),
      // More steps...
    ];

    return Form(
      child: Column(
        children: [
          StepperFormFields<Rx<AvailabilityFormStep>>(
            controller: controller,
            steps: steps,
            showAllSteps: !isCreation,
            scrollController: scrollController,
            enableAutoScroll: isCreation,
            showButtonCondition: () => controller.animationsComplete.value,
            isFinalStep: (step) => 
                step.value == AvailabilityFormStep.review,
            buttonLabelBuilder: (step) =>
                step.value == AvailabilityFormStep.review
                    ? 'Finalizar'
                    : 'Continuar',
          ),
        ],
      ),
    );
  }
}
```

---

## Best Practices

### 1. Consistent Naming

- **Form Widget**: `{Entity}Form` (e.g., `ProfileForm`, `LocationForm`)
- **Controller**: `{Entity}FormController`
- **Step Enum**: `{Entity}FormStep`
- **Step Widgets**: `{ConceptName}Step` (e.g., `NameStep`, `AddressStep`)

### 2. Controller Initialization

Always check if controller is already registered:

```dart
if (!Get.isRegistered<EntityFormController>()) {
  Get.put(EntityFormController(...));
}
```

This prevents duplicate instances when form is rebuilt.

### 3. Animation Timing

Use consistent timing for smooth transitions:

```dart
// Reset animation flag when moving to new step
animationsComplete.value = false;

// Re-enable after short delay
Future.delayed(Duration(milliseconds: 100), () {
  animationsComplete.value = true;
});
```

### 4. Validation Strategy

- **Inline validation**: For real-time feedback on individual fields
- **Step validation**: Before allowing progression to next step
- **Final validation**: Before form submission

### 5. Error Handling

```dart
try {
  loading.value = true;
  final result = await repository.save(data);
  onSavedCallback?.call(result);
} catch (e) {
  showErrorSnackbar(e.toString());
} finally {
  loading.value = false;
}
```

### 6. Repository Pattern

All data operations should go through repositories:

```dart
final EntityRepository repository = Get.find<EntityRepository>();

// Don't call API directly from controller
// Do use repository methods
final result = await repository.create(entity);
```

### 7. Callback vs Navigation

**Use callback** when:
- Form is part of a larger flow
- Parent needs to react to completion
- Multiple post-save actions needed

**Use navigation** when:
- Form is standalone
- Simple back navigation is sufficient

```dart
// Callback pattern
onSavedCallback?.call(result);

// Navigation pattern
Get.back(result: result);
```

### 8. Testing Considerations

Structure enables easy testing:

```dart
// Test controller logic
test('should move to next step on valid input', () {
  final controller = EntityFormController(isCreation: true);
  controller.nameController.text = 'Valid Name';
  controller.nextStep();
  expect(controller.currentStep.value, EntityFormStep.stepTwo);
});
```

---

## Integration into Setup Scope Flow

To add a new form to `SetupScopeFlow`:

### 1. Add Step to Enum

```dart
// In profile_model.dart or appropriate location
enum CreateProfileStep {
  profile,
  location,
  services,
  availability,  // New step
}
```

### 2. Create FlowStepConfig

```dart
// In setup_profile_flow.dart
Map<CreateProfileStep, FlowStepConfig Function(CreateProfileStep, SetupScopeController)> 
stepsConfigByType = {
  // ... existing steps
  CreateProfileStep.availability: (step, controller) => FlowStepConfig(
    step: step,
    title: 'Disponibilidad',
    stepTitle: 'Configurar Disponibilidad',
    svgAsset: "assets/images/svgs/availability.svg",
    build: () => AvailabilityForm(
      currentAvailability: controller.currentAvailability.value,
      isCreation: controller.currentAvailability.value?.id == null,
      scrollController: scrollController,
      onSaved: (availability) => controller.onAvailabilitySaved(availability),
    ),
  ),
};
```

### 3. Update Flow Controller

```dart
// In setup_scope_controller.dart
class SetupScopeController extends GetxController {
  final currentAvailability = Rx<AvailabilityModel?>(null);
  
  void onAvailabilitySaved(AvailabilityModel availability) {
    currentAvailability.value = availability;
    // Move to next step or complete flow
    goToNextStep();
  }
}
```

### Requirements for Flow Integration

1. **Callback Implementation**: Form must call `onSaved` callback
2. **Null Safety**: Handle both null and non-null current values
3. **Conditional Rendering**: Only render when dependencies are met
4. **State Persistence**: Controller should store form results

---

## Comparison: Different Form Types

### Step-Based Forms (Profile, Location)
- **Use Case**: Linear, sequential data collection
- **Pattern**: `StepperFormFields` + `StepperFormController`
- **Navigation**: Progressive disclosure
- **Best For**: User onboarding, setup wizards

### Complex State Forms (LocationServices)
- **Use Case**: Multiple sub-states, branching logic
- **Pattern**: `StatefulWidget` + custom controller
- **Navigation**: Internal state machine
- **Best For**: Configuration screens, bulk editing

### Simple Forms (Traditional)
- **Use Case**: Single-screen data entry
- **Pattern**: `Form` + `TextFormField`
- **Navigation**: None
- **Best For**: Login, settings, simple edits

---

## Common Patterns Summary

| Aspect | Creation Mode | Edit Mode |
|--------|--------------|-----------|
| `isCreation` | `true` | `false` |
| `showAllSteps` | `false` | `true` |
| `enableAutoScroll` | `true` | `false` |
| Step Visibility | Progressive | All visible |
| Button Label | Continuar/Finalizar | Guardar |
| Use Case | First-time setup | Modify existing |

---

## Troubleshooting

### Form not showing button

Check:
1. `animationsComplete.value` is `true`
2. `showButtonCondition` returns `true`
3. Current step is being set correctly

### Steps not appearing

Check:
1. Step conditions are returning `true`
2. `currentStep.value.index` is incrementing
3. `showAllSteps` is set appropriately

### Callback not firing

Check:
1. `onSavedCallback` is being called in controller
2. Callback is passed to form widget
3. Form submission is completing successfully

### Auto-scroll not working

Check:
1. `scrollController` is passed and has clients
2. `enableAutoScroll` is `true`
3. Button visibility change is triggering the effect

---

## Summary

The Bartoo form architecture provides:

✅ **Consistency**: All forms follow the same pattern  
✅ **Reusability**: Forms work standalone or in flows  
✅ **Flexibility**: Support both creation and editing  
✅ **Maintainability**: Clear separation of concerns  
✅ **User Experience**: Smooth animations and progressive disclosure  
✅ **Developer Experience**: Templates and clear contracts

By following this guide, new forms will integrate seamlessly with existing patterns and provide a consistent user experience throughout the application.
