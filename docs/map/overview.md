# Maps Overview

## What You Get
- Location Picker: full-screen map with centered pin and confirm flow
- Static Map View: non-interactive preview of a single LatLng
- Base Themed Map: shared, theme-aware Mapbox map foundation

## Quick Start
```dart
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

final location = await navigateToLocationPicker(
  context: context,
  title: 'Select Location',
);
if (location != null) {
  // use LatLng(latitude, longitude)
}
```

## Dependencies
- flutter_map ^8.1.1
- latlong2 ^0.9.1
- geolocator ^13.0.1
- flutter_dotenv ^5.1.0

## Environment (.env)
```env
MAPBOX_ACCESS_TOKEN=your_token
MAPBOX_DARK_STYLE_ID=mapbox/dark-v11
MAPBOX_DARK_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
MAPBOX_LIGHT_STYLE_ID=mapbox/streets-v12
MAPBOX_LIGHT_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
```

## Theming
- Uses a global ThemeManager (GetX) to switch styles
- BaseThemedMap rebuilds tiles when theme changes

## Troubleshooting
- Map not loading: check token/env and internet
- Null location on return: ensure `Navigator.pop(value)`
- Style stuck on dark: ensure ThemeManager toggles internal `isDark`

## More
- Location Picker: docs/map/location_picker.md
- Static Map: docs/map/static_map_view.md
- Theming & Styles: docs/map/theming.md
- Troubleshooting: docs/map/troubleshooting.md

