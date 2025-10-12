# Map Utils Usage Examples

This guide shows how to use the geolocation utilities to get location information and reverse geocoding (converting coordinates to addresses).

## Installation

The `geocoding` package is already added to the utils package dependencies.

## Available Functions

### 1. Get User's Current Location

```dart
import 'package:utils/geolocation/map_utils.dart';

// Get the user's current position
Position? position = await getUserCurrentLocation();

if (position != null) {
  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');
}
```

### 2. Get Address from Coordinates

```dart
import 'package:utils/geolocation/map_utils.dart';

// Get address information from latitude and longitude
AddressComponents? address = await getAddressFromCoordinates(
  latitude: 6.2442,
  longitude: -75.5812,
);

if (address != null) {
  print('City: ${address.city}');
  print('State: ${address.state}');
  print('Country: ${address.country}');
  print('Street: ${address.street}');
  print('Postal Code: ${address.postalCode}');
  print('Full Address: ${address.fullAddress}');
}
```

### 3. Get Address from Position Object

```dart
import 'package:utils/geolocation/map_utils.dart';

Position? position = await getUserCurrentLocation();

if (position != null) {
  AddressComponents? address = await getAddressFromPosition(position);
  
  if (address != null) {
    print('You are in: ${address.city}, ${address.state}, ${address.country}');
  }
}
```

### 4. Get Current Location with Address (All-in-One)

```dart
import 'package:utils/geolocation/map_utils.dart';

Map<String, dynamic>? locationData = await getCurrentLocationWithAddress();

if (locationData != null) {
  print('Latitude: ${locationData['latitude']}');
  print('Longitude: ${locationData['longitude']}');
  print('City: ${locationData['city']}');
  print('State: ${locationData['state']}');
  print('Country: ${locationData['country']}');
  
  Position position = locationData['position'];
  AddressComponents? address = locationData['address'];
}
```

## AddressComponents Model

The `AddressComponents` class contains the following fields:

- `street`: Street name and number
- `city`: City or locality name
- `state`: State or administrative area
- `country`: Country name
- `postalCode`: Postal or ZIP code
- `fullAddress`: Complete formatted address string

All fields are nullable and may not be available depending on the location and geocoding service response.

## Usage in Location Form Controller

The `LocationFormController` includes a convenient method to populate form fields from coordinates:

```dart
// After user selects a location on the map
Map<String, double> coordinates = {
  'latitude': 6.2442,
  'longitude': -75.5812,
};

// This will automatically populate the address, city, state, and country fields
await controller.getAddressFromLocation(coordinates);
```

## Platform Configuration

### Android

Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS

Add the following keys to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to show your current position on the map.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location to show your current position on the map.</string>
```

## Error Handling

All functions include error handling and will return `null` if an error occurs. Errors are printed to the console for debugging purposes.

```dart
AddressComponents? address = await getAddressFromCoordinates(
  latitude: latitude,
  longitude: longitude,
);

if (address == null) {
  // Handle error - coordinates might be invalid or network issue
  print('Failed to get address information');
}
```
