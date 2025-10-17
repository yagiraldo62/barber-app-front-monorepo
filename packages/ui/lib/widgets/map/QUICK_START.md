# Location Picker - Quick Start Guide

## 🚀 Quick Start (Copy & Paste Ready)

### Step 1: Import the helper

```dart
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';
```

### Step 2: Add a button to open the picker

```dart
ElevatedButton(
  onPressed: () async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Select Location',
    );
    
    if (location != null) {
      print('Selected: ${location.latitude}, ${location.longitude}');
      // Use the location here
    }
  },
  child: const Text('Pick Location'),
)
```

That's it! 🎉

---

## 📋 Complete Working Example

```dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

class MyLocationScreen extends StatefulWidget {
  const MyLocationScreen({super.key});

  @override
  State<MyLocationScreen> createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  LatLng? _selectedLocation;

  Future<void> _pickLocation() async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Select Your Location',
      confirmButtonText: 'CONFIRM',
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedLocation != null) ...[
              Text('Latitude: ${_selectedLocation!.latitude}'),
              Text('Longitude: ${_selectedLocation!.longitude}'),
              const SizedBox(height: 20),
            ],
            ElevatedButton.icon(
              onPressed: _pickLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Pick Location'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Common Use Cases

### 1. Business Registration

```dart
Future<void> registerBusiness() async {
  final location = await navigateToLocationPicker(
    context: context,
    title: 'Select Business Location',
  );
  
  if (location != null) {
    await api.createBusiness(
      name: businessName,
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}
```

### 2. Update User Profile

```dart
Future<void> updateUserLocation() async {
  final location = await navigateToLocationPicker(
    context: context,
    initialLocation: LatLng(
      user.currentLatitude,
      user.currentLongitude,
    ),
    title: 'Update Your Location',
  );
  
  if (location != null) {
    await userRepository.updateLocation(location);
  }
}
```

### 3. Service Request

```dart
Future<void> requestService() async {
  final serviceLocation = await navigateToLocationPicker(
    context: context,
    title: 'Where do you need the service?',
  );
  
  if (serviceLocation != null) {
    await api.createServiceRequest(
      serviceType: selectedService,
      location: serviceLocation,
    );
  }
}
```

---

## 🎨 Customization Options

### With Initial Location

```dart
await navigateToLocationPicker(
  context: context,
  initialLocation: LatLng(4.7110, -74.0721), // Bogotá, Colombia
  title: 'Select Location',
);
```

### Custom Button Text

```dart
await navigateToLocationPicker(
  context: context,
  confirmButtonText: 'SAVE LOCATION',
);
```

### Full Customization

```dart
await navigateToLocationPicker(
  context: context,
  initialLocation: LatLng(4.7110, -74.0721),
  title: 'Pick Your Business Location',
  confirmButtonText: 'CONFIRM',
);
```

---

## 🔧 Prerequisites Checklist

- [x] `flutter_map: ^8.1.1` in pubspec.yaml
- [x] `latlong2: ^0.9.1` in pubspec.yaml
- [x] `geolocator: ^13.0.1` in pubspec.yaml
- [ ] MapBox access token in `.env` file
- [ ] Location permissions in AndroidManifest.xml
- [ ] Location permissions in Info.plist (iOS)

### Environment Variables (.env)

```env
MAPBOX_ACCESS_TOKEN=your_token_here
MAPBOX_DARK_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
MAPBOX_DARK_STYLE_ID=mapbox/dark-v11
```

---

## 📱 How It Works (User Flow)

1. User taps "Pick Location" button
2. Map opens with a red person pin in the center
3. User sees instructions: "Move the map to place the pin on your desired location"
4. User drags the map around (pin stays centered)
5. User can tap "My Location" button to center on GPS
6. User taps "Confirm Location" button
7. Selected coordinates are returned to your app

---

## 💡 Pro Tips

1. **Always check for null**: The function returns `null` if user cancels
   ```dart
   if (location != null) {
     // Use the location
   }
   ```

2. **Show loading indicator**: While saving the location
   ```dart
   if (location != null) {
     showLoadingDialog();
     await saveLocation(location);
     hideLoadingDialog();
   }
   ```

3. **Format coordinates**: For display
   ```dart
   String formatCoordinates(LatLng location) {
     return '${location.latitude.toStringAsFixed(6)}, '
            '${location.longitude.toStringAsFixed(6)}';
   }
   ```

4. **Validate selection**: Before submitting forms
   ```dart
   void submitForm() {
     if (_selectedLocation == null) {
       showSnackBar('Please select a location');
       return;
     }
     // Continue with submission
   }
   ```

---

## 🐛 Troubleshooting

### Map not loading?
- Check your MapBox token is valid
- Verify `.env` file is loaded in `main.dart`
- Check internet connection

### Location permission denied?
- Add permissions to AndroidManifest.xml (Android)
- Add usage descriptions to Info.plist (iOS)
- Request permissions at runtime

### App crashes on location picker?
- Ensure all dependencies are installed
- Run `flutter pub get`
- Check that `.env` file exists

---

## 📚 More Examples

See these files for more complex examples:
- `location_picker_example.dart` - Complete demo app
- `integration_examples.dart` - Real-world use cases
- `LOCATION_PICKER_README.md` - Full documentation

---

## 🤝 Need Help?

1. Check the example files
2. Review the README documentation
3. Ensure all prerequisites are met
4. Test with the example app first

---

Made with ❤️ for the Bartoo project
