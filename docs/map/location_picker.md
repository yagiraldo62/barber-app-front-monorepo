# Location Picker (Summary)

## Purpose
Full-screen selector with a centered pin. User moves the map; the pin stays centered. On confirm, returns `LatLng`.

## Basic Use
```dart
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

final result = await navigateToLocationPicker(
  context: context,
  title: 'Select Location',
  confirmButtonText: 'CONFIRM',
);
if (result != null) {
  // LatLng available
}
```

## Options
- `initialLocation`: starting LatLng
- `title`: app bar title
- `confirmButtonText`: confirm button label

## UX Details
- Center pin offset so the point-tip aligns to map center
- Recommended zoom: ~17 for street-level precision
- "My Location" button recenters to GPS

## Common Patterns
- Prefill with saved location when editing
- Validate selection before form submit
- Use `Obx`/state to show preview after selection

## Where To Dive Deeper
- Full guide: packages/ui/lib/widgets/map/LOCATION_PICKER_README.md
- Quick start: packages/ui/lib/widgets/map/QUICK_START.md
- Examples: packages/ui/lib/widgets/map/location_picker_example.dart
