# StepperFormFields - Show All Steps Feature

## Overview

The `StepperFormFields` widget now supports two display modes:

1. **Progressive Mode** (default) - Steps are revealed progressively based on conditions
2. **Show All Mode** - All steps are visible from the start

## Usage

### Progressive Mode (Default)

Steps are shown based on their conditions. Each step becomes visible when its condition returns `true`.

```dart
StepperFormFields<Rx<LocationFormStep>>(
  controller: controller,
  steps: steps,
  isFinalStep: (step) => step.value == LocationFormStep.location,
  scrollController: scrollController,
  showButtonCondition: () => controller.animationsComplete.value,
  // showAllSteps: false, // Default behavior
)
```

**Behavior:**
- Only steps with `condition()` returning `true` are displayed
- Steps appear progressively as you move through the form
- Useful for guided step-by-step forms

---

### Show All Steps Mode

All steps are visible from the beginning, regardless of their conditions.

```dart
StepperFormFields<Rx<LocationFormStep>>(
  controller: controller,
  steps: steps,
  isFinalStep: (step) => step.value == LocationFormStep.location,
  scrollController: scrollController,
  showAllSteps: true, // Show all steps at once
  showButtonCondition: () => controller.animationsComplete.value,
)
```

**Behavior:**
- All steps are visible immediately
- Step conditions are ignored for visibility
- Users can see the entire form structure at once
- Useful for forms where users need to see all fields upfront

---

## Parameter Details

### `showAllSteps`

**Type:** `bool`  
**Default:** `false`  
**Description:** Controls whether all steps should be visible at once or revealed progressively.

- **`false`** (default): Progressive mode - respects step conditions
- **`true`**: Show all mode - ignores step conditions, shows everything

---

## Examples

### Example 1: Profile Form with Progressive Steps

```dart
final steps = [
  StepInfo(
    stepWidget: NameStep(controller: controller),
    condition: () => controller.currentStep.value.index >= ProfileFormStep.name.index,
  ),
  StepInfo(
    stepWidget: TitleStep(controller: controller),
    condition: () => controller.currentStep.value.index >= ProfileFormStep.title.index,
  ),
  StepInfo(
    stepWidget: DescriptionStep(controller: controller),
    condition: () => controller.currentStep.value.index >= ProfileFormStep.description.index,
  ),
];

// Progressive display
StepperFormFields<Rx<ProfileFormStep>>(
  controller: controller,
  steps: steps,
  isFinalStep: (step) => step.value == ProfileFormStep.photo,
  // Steps revealed one by one as user progresses
)
```

### Example 2: Settings Form with All Steps Visible

```dart
final steps = [
  StepInfo(
    stepWidget: AccountSettings(controller: controller),
    condition: () => true, // This condition is ignored in showAllSteps mode
  ),
  StepInfo(
    stepWidget: NotificationSettings(controller: controller),
    condition: () => true, // This condition is ignored in showAllSteps mode
  ),
  StepInfo(
    stepWidget: PrivacySettings(controller: controller),
    condition: () => true, // This condition is ignored in showAllSteps mode
  ),
];

// All settings visible at once
StepperFormFields<Rx<SettingsStep>>(
  controller: controller,
  steps: steps,
  showAllSteps: true, // Show everything
  isFinalStep: (step) => step.value == SettingsStep.privacy,
  buttonLabel: 'Save Settings',
)
```

### Example 3: Location Form - Switching Between Modes

```dart
class LocationFormWidget extends StatelessWidget {
  final bool showAllStepsAtOnce;
  
  const LocationFormWidget({
    this.showAllStepsAtOnce = false,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      StepInfo(
        stepWidget: LocationNameStep(controller: controller),
        condition: () => controller.currentStep.value.index >= 0,
      ),
      StepInfo(
        stepWidget: LocationAddressStep(controller: controller),
        condition: () => controller.currentStep.value.index >= 1,
      ),
      StepInfo(
        stepWidget: LocationMapStep(controller: controller),
        condition: () => controller.currentStep.value.index >= 2,
      ),
    ];

    return StepperFormFields<Rx<LocationFormStep>>(
      controller: controller,
      steps: steps,
      showAllSteps: showAllStepsAtOnce, // Dynamic mode
      isFinalStep: (step) => step.value == LocationFormStep.location,
    );
  }
}
```

---

## When to Use Each Mode

### Use Progressive Mode (default) when:

✅ Guiding users through a complex process  
✅ Steps depend on previous step completion  
✅ Reducing cognitive load by showing one step at a time  
✅ Form validation requires sequential completion  
✅ Creating onboarding or setup flows  

**Examples:**
- User registration/onboarding
- Profile creation wizards
- Multi-step checkout processes
- Setup wizards

### Use Show All Mode when:

✅ Users need to see the complete form structure  
✅ Steps are independent of each other  
✅ Users may want to jump between sections  
✅ Form is relatively short and simple  
✅ Users are familiar with the process  

**Examples:**
- Settings/preferences pages
- Simple data entry forms
- Edit profile forms
- Configuration forms

---

## Migration Guide

If you have existing `StepperFormFields` usage, no changes are required. The default behavior remains unchanged (progressive mode).

To enable show all mode, simply add the parameter:

```dart
// Before (still works the same)
StepperFormFields<Rx<MyStep>>(
  controller: controller,
  steps: steps,
  isFinalStep: isFinal,
)

// After (with show all mode)
StepperFormFields<Rx<MyStep>>(
  controller: controller,
  steps: steps,
  isFinalStep: isFinal,
  showAllSteps: true, // Add this line
)
```

---

## Technical Details

### Implementation

The `showAllSteps` parameter modifies the step visibility logic:

```dart
// Progressive mode (showAllSteps = false)
if (!showAllSteps && step.condition != null && !step.condition!()) {
  continue; // Skip this step
}

// Show all mode (showAllSteps = true)
// Condition is ignored, all steps are shown
```

### Performance Considerations

- **Progressive mode**: Only visible steps are rendered
- **Show all mode**: All steps are rendered at once
  - May impact performance for forms with many complex steps
  - Consider using `ListView.builder` for very long forms

### Reactive Updates

Both modes work with GetX reactive updates:
- The widget wraps content in `Obx()`
- Steps automatically update when controller state changes
- Animations apply to all steps regardless of mode

---

## Best Practices

1. **Use step conditions wisely**
   - In progressive mode, conditions control visibility
   - In show all mode, conditions are ignored
   - Consider setting conditions to simple boolean checks

2. **Scroll behavior**
   - Provide a `scrollController` for better UX
   - Auto-scroll works in both modes
   - Users can manually scroll in show all mode

3. **Button placement**
   - Continue/Submit button always appears at the bottom
   - Use `buttonAlignment` to position the button
   - Button responds to `isFinalStep` in both modes

4. **Form validation**
   - Validate each step regardless of display mode
   - Show validation errors clearly
   - Don't rely on visibility for validation logic

---

## Related Components

- `StepInfo` - Container for step widget and condition
- `StepperFormController` - Base controller interface
- `AppButton` - Button component used for navigation
- `AppStepper` - Separate stepper component for navigation indicators

---

## Changelog

### Version 1.1.0
- ✨ Added `showAllSteps` parameter
- 📝 Updated documentation
- ✅ Backward compatible with existing usage
