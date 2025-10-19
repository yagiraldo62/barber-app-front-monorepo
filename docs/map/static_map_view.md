# Static Map View (Summary)

## Purpose
Non-interactive map preview for a single `LatLng`. Ideal for showing a selected location in forms, lists, and cards.

## Basic Use
```dart
import 'package:ui/widgets/map/static_map_view.dart';
import 'package:latlong2/latlong.dart';

Container(
  height: 300,
  child: StaticMapView(
    location: LatLng(4.7110, -74.0721),
    zoom: 16.0,
  ),
)
```

## Options
- `location` (required): LatLng
- `zoom` (default 15.0)
- `showMarker` (default true)
- `markerIcon` (default `Icons.person_pin_circle`)
- `markerColor` (default red)
- `markerSize` (default 40)
- `enableInteractions` (default false)

## Notes
- Marker vertically offset by 50% of icon size for accurate tip alignment
- Respects theme via BaseThemedMap

## Where To Dive Deeper
- Readme: packages/ui/lib/widgets/map/STATIC_MAP_VIEW_README.md
- Examples: packages/ui/lib/widgets/map/static_map_view_example.dart
