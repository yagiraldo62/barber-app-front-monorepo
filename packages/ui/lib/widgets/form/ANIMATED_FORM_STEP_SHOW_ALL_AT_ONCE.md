# AnimatedFormStep - Show All At Once Feature

## Overview

The `AnimatedFormStep` widget now supports two display modes:

1. **Progressive Animation Mode** (default) - Components appear sequentially with typing animations
2. **Show All At Once Mode** - All components appear immediately without animations

## Usage

### Progressive Animation Mode (Default)

Components appear sequentially with typing animations for a guided, engaging user experience.

```dart
AnimatedFormStep(
  title: 'Enter your name',
  introText: 'Step 1 of 5',
  descriptionText: 'Please provide your full legal name',
  content: TextField(
    decoration: InputDecoration(labelText: 'Name'),
  ),
  focusNode: nameFocusNode,
  onAnimationsComplete: () => print('Animations done!'),
  // showAllAtOnce: false, // Default behavior
)
```

**Animation Sequence:**
1. Intro text types out (if provided)
2. Title text types out
3. Description text types out (if provided)
4. Content fades in
5. Focus is requested (if focusNode provided)
6. Callback fires when complete

---

### Show All At Once Mode

All components appear immediately for faster form completion or when animations aren't needed.

```dart
AnimatedFormStep(
  title: 'Enter your name',
  introText: 'Step 1 of 5',
  descriptionText: 'Please provide your full legal name',
  content: TextField(
    decoration: InputDecoration(labelText: 'Name'),
  ),
  focusNode: nameFocusNode,
  showAllAtOnce: true, // Show everything immediately
  onAnimationsComplete: () => print('Ready!'),
)
```

**Behavior:**
- All text appears immediately (no typing animation)
- Content appears immediately (no fade-in)
- Focus requested after short delay (100ms)
- Callback fires immediately
- No animation delays

---

## Parameter Details

### `showAllAtOnce`

**Type:** `bool`  
**Default:** `false`  
**Description:** Controls whether components appear progressively with animations or all at once.

- **`false`** (default): Progressive mode - typing animations and sequential reveal
- **`true`**: Instant mode - all components visible immediately

---

## Examples

### Example 1: Profile Setup with Progressive Animation

```dart
class NameStep extends StatelessWidget {
  final FocusNode nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Cómo te llamas?',
      introText: 'Paso 1 de 5',
      descriptionText: 'Ingresa tu nombre completo como aparece en tu documento',
      content: TextField(
        focusNode: nameFocus,
        decoration: InputDecoration(
          labelText: 'Nombre completo',
          hintText: 'Juan Pérez',
        ),
      ),
      focusNode: nameFocus,
      onAnimationsComplete: () {
        // Track when user can interact
        analytics.logEvent('name_step_ready');
      },
    );
  }
}
```

### Example 2: Quick Edit Form (No Animations)

```dart
class QuickEditName extends StatelessWidget {
  final FocusNode nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Editar nombre',
      descriptionText: 'Actualiza tu nombre si es necesario',
      content: TextField(
        focusNode: nameFocus,
        decoration: InputDecoration(labelText: 'Nombre'),
      ),
      focusNode: nameFocus,
      showAllAtOnce: true, // No animations for quick edits
    );
  }
}
```

### Example 3: Conditional Animation Based on User Preference

```dart
class AdaptiveFormStep extends StatelessWidget {
  final bool userPrefersAnimations;
  final FocusNode focusNode = FocusNode();

  const AdaptiveFormStep({
    required this.userPrefersAnimations,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Your email address',
      introText: 'Step 2 of 5',
      content: TextField(
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'you@example.com',
        ),
      ),
      focusNode: focusNode,
      // Respect user preference
      showAllAtOnce: !userPrefersAnimations,
    );
  }
}
```

### Example 4: Settings Form (Always Instant)

```dart
class SettingsFormStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Notification Preferences',
      descriptionText: 'Choose how you want to be notified',
      content: Column(
        children: [
          SwitchListTile(
            title: Text('Email notifications'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: Text('Push notifications'),
            value: false,
            onChanged: (val) {},
          ),
        ],
      ),
      showAllAtOnce: true, // Settings should be immediately visible
    );
  }
}
```

---

## When to Use Each Mode

### Use Progressive Animation Mode (default) when:

✅ Creating onboarding or first-time user flows  
✅ Building guided step-by-step forms  
✅ Wanting to draw attention to each field  
✅ Creating an engaging, polished UX  
✅ Form is part of a tutorial or learning flow  
✅ You want to control the pace of interaction  

**Examples:**
- User registration flows
- Profile setup wizards
- Onboarding forms
- Tutorial steps
- First-time configuration

### Use Show All At Once Mode when:

✅ Users are editing existing data  
✅ Form is frequently accessed/familiar  
✅ Speed is more important than polish  
✅ Animations would be annoying/repetitive  
✅ Accessibility concerns (motion sensitivity)  
✅ Users have disabled animations in settings  

**Examples:**
- Settings/preferences forms
- Edit profile forms
- Quick data entry forms
- Admin/power user interfaces
- Forms accessed multiple times

---

## Performance Considerations

### Progressive Mode
- **Pros:** Smoother perceived performance, guided experience
- **Cons:** Longer time to interaction, multiple state updates
- **Best for:** First-time users, important flows

### Show All Mode
- **Pros:** Instant time to interaction, single render
- **Cons:** Less polished, all content loads at once
- **Best for:** Repeat users, quick tasks

---

## Comparison Table

| Feature | Progressive Mode | Show All Mode |
|---------|-----------------|---------------|
| Animation | ✅ Typing + Fade | ❌ None |
| Time to Interactive | ~2-4 seconds | ~100ms |
| Focus Behavior | After animations | Immediate |
| Callback Timing | After animations | Immediate |
| User Control | Passive watching | Immediate interaction |
| Best For | Onboarding | Editing/Settings |

---

## Technical Implementation

### Progressive Mode Flow

```
initState() called
    ↓
_startAnimationSequence()
    ↓
Show intro (if provided) → Type animation
    ↓
Show title → Type animation
    ↓
Show description (if provided) → Type animation
    ↓
Show content → Fade in
    ↓
Request focus (after delay)
    ↓
Fire onAnimationsComplete callback
```

### Show All At Once Flow

```
initState() called
    ↓
_showAllImmediately()
    ↓
Set all visibility flags to true
Set all opacity to 1.0
    ↓
Request focus (after 100ms)
Fire onAnimationsComplete callback immediately
    ↓
Render all components at once
```

---

## Accessibility Considerations

### Motion Sensitivity

Users with motion sensitivity or vestibular disorders may prefer no animations:

```dart
class AccessibleFormStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check platform accessibility settings
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    
    return AnimatedFormStep(
      title: 'Your information',
      content: MyFormFields(),
      // Disable animations if user prefers reduced motion
      showAllAtOnce: reduceMotion,
    );
  }
}
```

### Screen Readers

Both modes work well with screen readers:
- **Progressive mode:** Elements announced as they appear
- **Show all mode:** All elements announced immediately

---

## Migration Guide

Existing code continues to work unchanged. The default behavior is progressive animation.

```dart
// Before (still works the same)
AnimatedFormStep(
  title: 'Step title',
  content: MyContent(),
)

// After (with instant mode option)
AnimatedFormStep(
  title: 'Step title',
  content: MyContent(),
  showAllAtOnce: true, // Add this to disable animations
)
```

---

## Best Practices

### 1. **Consider User Context**
```dart
// First time setup: use animations
AnimatedFormStep(
  title: 'Create your profile',
  showAllAtOnce: false,
)

// Editing existing: skip animations
AnimatedFormStep(
  title: 'Edit your profile',
  showAllAtOnce: true,
)
```

### 2. **Respect System Settings**
```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;
AnimatedFormStep(
  title: 'Form step',
  content: content,
  showAllAtOnce: reduceMotion,
)
```

### 3. **Be Consistent Within a Flow**
Don't mix modes within the same form - choose one approach and stick with it.

### 4. **Test Both Modes**
Ensure your form works well in both modes, especially:
- Focus behavior
- Keyboard navigation
- Screen reader compatibility

---

## Animation Customization

Even in progressive mode, you can customize timing:

```dart
AnimatedFormStep(
  title: 'Quick step',
  content: content,
  // Speed up animations
  titleDuration: Duration(milliseconds: 400),
  fadeDuration: Duration(milliseconds: 200),
  focusDelay: Duration(milliseconds: 200),
  // Or skip them entirely
  // showAllAtOnce: true,
)
```

---

## Related Components

- `TypingText` - Used for text animations in progressive mode
- `Typography` - Used for static text in show all mode
- `StepperFormFields` - Parent form component (also has `showAllSteps` option)

---

## Changelog

### Version 1.1.0
- ✨ Added `showAllAtOnce` parameter
- 🎨 Improved accessibility with instant mode
- 📝 Comprehensive documentation
- ✅ Backward compatible

---

## Common Patterns

### Pattern 1: User Preference Toggle

```dart
class MyApp extends StatelessWidget {
  final bool animationsEnabled = true; // From user settings

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: 'Form Step',
      content: content,
      showAllAtOnce: !animationsEnabled,
    );
  }
}
```

### Pattern 2: Context-Aware Animation

```dart
AnimatedFormStep(
  title: 'Step',
  content: content,
  // Animate on first visit, instant on return
  showAllAtOnce: !isFirstVisit,
)
```

### Pattern 3: Performance Mode

```dart
AnimatedFormStep(
  title: 'Step',
  content: content,
  // Skip animations on low-end devices
  showAllAtOnce: isLowEndDevice,
)
```

---

## Troubleshooting

**Q: Focus not working in show all mode?**  
A: There's a 100ms delay before focus request. This is intentional to ensure the widget is fully mounted.

**Q: Callback fires too early?**  
A: In show all mode, the callback fires immediately since there are no animations to wait for.

**Q: Want faster animations, not instant?**  
A: Use progressive mode and reduce the duration parameters instead of enabling `showAllAtOnce`.

---

For more examples and advanced usage, see the example project.
