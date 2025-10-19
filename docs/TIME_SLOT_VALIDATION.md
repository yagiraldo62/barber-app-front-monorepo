# Time Slot Validation

## Overview

This document describes the time slot validation system implemented to prevent overlapping time slots in the availability form.

## How It Works

### TimeSelector Widget Enhancement

The `TimeSelector` widget now accepts an optional `isTimeDisabled` callback function:

```dart
TimeSelector(
  initialValue: selectedTime,
  labelText: 'Inicio',
  availableTimes: times,
  isTimeDisabled: (time) => controller.isTimeDisabledForSlot(
    weekday: weekday,
    slotIndex: index,
    time: time,
    isStartTime: true,
  ),
  onChanged: (val) {
    controller.updateSlotStart(weekday, index, val);
  },
)
```

### Validation Logic

The `AvailabilityFormController` provides the `isTimeDisabledForSlot` method that checks:

#### For Start Time:
1. **Overlap Prevention**: Disables times that fall within another slot's range
2. **Forward Validation**: Disables times that would cause the current slot's end time to overlap with other slots

#### For End Time:
1. **Temporal Order**: Disables times that are before or equal to the start time
2. **Overlap Prevention**: Disables times that fall within another slot's range
3. **Backward Validation**: Disables times that would cause overlap with slots that start before the current slot

### Example Scenarios

#### Scenario 1: Single Existing Slot
```
Existing: 09:00 - 12:00

Adding new slot:
- Start time disabled: 09:00, 09:15, 09:30, ..., 11:45
- Start time enabled: 00:00-08:45, 12:00-23:45
```

#### Scenario 2: Multiple Existing Slots
```
Slot 1: 08:00 - 10:00
Slot 2: 14:00 - 18:00

Adding Slot 3:
- Start time disabled: 08:00-09:45, 14:00-17:45
- Start time enabled: 00:00-07:45, 10:00-13:45, 18:00-23:45
```

#### Scenario 3: Editing End Time
```
Current Slot: 09:00 - 12:00
Other Slot: 14:00 - 18:00

Editing end time:
- Disabled: 00:00-09:00 (before/equal to start), 14:15-18:00 (overlap with other slot)
- Enabled: 09:15-14:00, 18:15-23:45
```

## Visual Feedback

When a time is disabled:
- The text appears grayed out (30% opacity)
- The icon appears grayed out (30% opacity)
- The list item is not tappable
- Users cannot select disabled times

## Benefits

1. **Prevents Data Conflicts**: No overlapping time slots can be created
2. **Better UX**: Visual indication of why certain times cannot be selected
3. **Data Integrity**: Ensures all time slots are valid and non-conflicting
4. **Intuitive**: Users can immediately see available time ranges

## Implementation Details

### Controller Method Signature

```dart
bool isTimeDisabledForSlot({
  required int weekday,
  required int slotIndex,
  required TimeOfDayModel time,
  required bool isStartTime,
})
```

### Parameters:
- `weekday`: The day of the week (1-7, Monday-Sunday)
- `slotIndex`: The index of the slot being edited
- `time`: The time to check
- `isStartTime`: Whether checking for start time (true) or end time (false)

### Return Value:
- `true`: The time should be disabled
- `false`: The time is available for selection

## Future Enhancements

Potential improvements:
1. Add minimum slot duration validation (e.g., minimum 30 minutes)
2. Add maximum slot duration validation
3. Add break time requirements between slots
4. Visual indicators showing conflicting slots when hovering over disabled times
5. Smart suggestions for available time ranges
