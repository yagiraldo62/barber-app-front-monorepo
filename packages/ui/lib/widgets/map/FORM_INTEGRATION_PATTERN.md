# Quick Reference: Using Location Picker in Forms

## Basic Pattern

```dart
import 'package:ui/widgets/map/location_picker_helper.dart';
import 'package:latlong2/latlong.dart';

// In your form step widget
Future<void> _selectLocation(BuildContext context) async {
  final selectedLocation = await navigateToLocationPicker(
    context: context,
    initialLocation: controller.location.value, // Optional
    title: 'Select Location',
  );

  if (selectedLocation != null) {
    controller.setLocation(selectedLocation);
  }
}
```

## With Obx (Reactive UI)

```dart
Obx(() {
  final location = controller.location.value;
  
  return Column(
    children: [
      ElevatedButton(
        onPressed: () => _selectLocation(context),
        child: Text(location != null ? 'Change Location' : 'Select Location'),
      ),
      
      if (location != null)
        Text('Lat: ${location.latitude}, Lng: ${location.longitude}'),
    ],
  );
})
```

## Complete Form Step Example

```dart
class LocationMapStep extends StatelessWidget {
  final LocationFormController controller;

  const LocationMapStep({super.key, required this.controller});

  Future<void> _selectLocation(BuildContext context) async {
    final selectedLocation = await navigateToLocationPicker(
      context: context,
      initialLocation: controller.location.value,
      title: 'Select Your Location',
    );

    if (selectedLocation != null) {
      controller.setLocation(selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final location = controller.location.value;
      
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => _selectLocation(context),
            icon: const Icon(Icons.map),
            label: Text(
              location != null ? 'Change Location' : 'Select Location',
            ),
          ),
          
          if (location != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Location Selected'),
                    Text('Lat: ${location.latitude.toStringAsFixed(6)}'),
                    Text('Lng: ${location.longitude.toStringAsFixed(6)}'),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
```

## Controller Requirements

Your controller needs:

```dart
class YourFormController extends GetxController {
  // Observable location property
  final Rx<LatLng?> location = Rx<LatLng?>(null);
  
  // Setter method
  void setLocation(LatLng latLng) {
    location.value = latLng;
  }
}
```

## Imports Needed

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';
```

## Common Patterns

### 1. Edit Existing Location
```dart
await navigateToLocationPicker(
  context: context,
  initialLocation: existingLocation, // Pre-fill with saved location
);
```

### 2. Custom Text
```dart
await navigateToLocationPicker(
  context: context,
  title: 'Where is your business?',
  confirmButtonText: 'SAVE',
);
```

### 3. Validation
```dart
void submit() {
  if (controller.location.value == null) {
    Get.snackbar('Error', 'Please select a location');
    return;
  }
  // Continue...
}
```

### 4. Convert to Map (for API)
```dart
Map<String, double> getLocationData() {
  final loc = controller.location.value;
  return {
    'latitude': loc.latitude,
    'longitude': loc.longitude,
  };
}
```

## Tips

✅ Always check for null before using location
✅ Use Obx() for reactive updates
✅ Provide initialLocation when editing
✅ Show visual feedback when location is selected
✅ Validate location before form submission

## Complete Flow

```
User → Button Click → navigateToLocationPicker()
                              ↓
                         Map Opens
                              ↓
                      User Selects Location
                              ↓
                         Confirms
                              ↓
                    controller.setLocation()
                              ↓
                        UI Updates (Obx)
                              ↓
                    Ready for Submission
```

That's it! 🎉
