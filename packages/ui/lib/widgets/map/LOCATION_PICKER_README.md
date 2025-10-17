# Location Picker Widget

A comprehensive MapBox-based location picker widget for Flutter that allows users to select a location by moving a map with a centered pin marker.

## Features

- 🗺️ MapBox integration with Flutter Maps
- 📍 Centered person pin marker for easy location selection
- 🎯 Current location detection and centering
- 🎨 Customizable UI (title, button text, etc.)
- 📱 Responsive design with helpful instructions
- ✅ Easy-to-use callback system
- 🔄 Multiple usage patterns (full page, inline widget)

## Components

### 1. LocationPickerPage
The main page widget that displays the map with location picker functionality.

### 2. LocationPickerHelper
Helper functions and widgets for easy integration:
- `navigateToLocationPicker()` - Navigation function
- `LocationPickerWidget` - Inline widget version

### 3. LocationPickerExample
Example implementation showing different usage patterns.

## Installation

The required dependencies are already in the `ui` package:

```yaml
dependencies:
  flutter_map: ^8.1.1
  latlong2: ^0.9.1
  geolocator: ^13.0.1
  flutter_dotenv: ^5.1.0
```

## Environment Setup

Make sure your `.env` file contains the MapBox configuration:

```env
MAPBOX_ACCESS_TOKEN=your_mapbox_access_token_here
MAPBOX_DARK_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
MAPBOX_DARK_STYLE_ID=mapbox/dark-v11
```

## Permissions

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to help you select your business location.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to help you select your business location.</string>
```

## Usage

### Basic Usage (Recommended)

```dart
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

// In your widget
Future<void> _selectLocation() async {
  final selectedLocation = await navigateToLocationPicker(
    context: context,
    initialLocation: LatLng(4.7110, -74.0721), // Optional: Initial position
    title: 'Select Your Location',
    confirmButtonText: 'CONFIRM',
  );

  if (selectedLocation != null) {
    print('Latitude: ${selectedLocation.latitude}');
    print('Longitude: ${selectedLocation.longitude}');
    
    // Use the selected location
    await saveLocation(selectedLocation);
  }
}
```

### Usage with Current Location

```dart
// Will automatically detect and use current GPS location
final location = await navigateToLocationPicker(
  context: context,
  title: 'Select Location',
);
```

### Advanced Usage with Custom Widget

```dart
import 'package:ui/widgets/map/location_picker_page.dart';

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => LocationPickerPage(
      initialLocation: LatLng(4.7110, -74.0721),
      onLocationSelected: (LatLng location) {
        // Handle the selected location
        print('Selected: ${location.latitude}, ${location.longitude}');
      },
      title: 'Custom Title',
      confirmButtonText: 'SAVE',
    ),
  ),
);
```

### Inline Widget Usage

```dart
import 'package:ui/widgets/map/location_picker_helper.dart';

LocationPickerWidget(
  initialLocation: LatLng(4.7110, -74.0721),
  height: 400,
  showConfirmButton: true,
  onLocationSelected: (LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  },
)
```

## API Reference

### navigateToLocationPicker()

```dart
Future<LatLng?> navigateToLocationPicker({
  required BuildContext context,
  LatLng? initialLocation,        // Optional initial position
  String? title,                   // Optional custom title
  String? confirmButtonText,       // Optional button text
})
```

**Returns:** `Future<LatLng?>` - The selected location or null if cancelled

### LocationPickerPage

```dart
LocationPickerPage({
  LatLng? initialLocation,
  required Function(LatLng) onLocationSelected,
  String? title,
  String? confirmButtonText,
})
```

**Properties:**
- `initialLocation`: Starting position of the map
- `onLocationSelected`: Callback when location is confirmed
- `title`: Custom app bar title
- `confirmButtonText`: Custom confirm button text

### LocationPickerWidget

```dart
LocationPickerWidget({
  LatLng? initialLocation,
  required Function(LatLng) onLocationSelected,
  double? height,
  bool showConfirmButton = true,
})
```

## User Experience

1. **Map Opens**: The map centers on either the provided location or current GPS position
2. **Helper Text**: Instructions appear at the top guiding the user
3. **Center Pin**: A red person pin icon is fixed at the center of the screen
4. **Map Movement**: User drags the map to position the desired location under the pin
5. **Current Location Button**: Floating button to quickly center on GPS position
6. **Confirmation**: User taps "Confirm Location" button to select
7. **Callback**: The selected coordinates are passed back via callback

## Customization

### Change Pin Icon

Edit `location_picker_page.dart`:

```dart
const Icon(
  Icons.location_on,  // Change this to any icon
  size: 50,
  color: Colors.blue, // Change color
)
```

### Change Map Style

Edit the MapBox URL in your `.env` file:
- `mapbox/streets-v11` - Streets style
- `mapbox/outdoors-v11` - Outdoors style
- `mapbox/light-v11` - Light style
- `mapbox/dark-v11` - Dark style (default)
- `mapbox/satellite-v9` - Satellite imagery

### Custom Theme

The widget respects your app's theme for colors and styles. The primary color is used for the confirm button.

## Troubleshooting

### Map not loading
- Verify your MapBox access token is correct
- Check internet connection
- Ensure MAPBOX_ACCESS_TOKEN is in your .env file

### Location permission denied
- Check that permissions are added to AndroidManifest.xml and Info.plist
- Request permissions at runtime using the geolocator package

### Map tiles showing error
- Verify the MAPBOX_DARK_URL and MAPBOX_DARK_STYLE_ID are correct
- Check MapBox account is active and has quota

## Example

See `location_picker_example.dart` for a complete working example with multiple usage patterns.

## License

This component is part of the Bartoo monorepo UI package.
