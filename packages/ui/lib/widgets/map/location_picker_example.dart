import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

/// Example usage of the Location Picker Widget
/// This demonstrates different ways to use the location picker in your app
class LocationPickerExample extends StatefulWidget {
  const LocationPickerExample({super.key});

  @override
  State<LocationPickerExample> createState() => _LocationPickerExampleState();
}

class _LocationPickerExampleState extends State<LocationPickerExample> {
  LatLng? _selectedLocation;

  /// Example 1: Navigate to location picker as a full page
  Future<void> _openLocationPickerFullPage() async {
    final location = await navigateToLocationPicker(
      context: context,
      initialLocation: const LatLng(4.7110, -74.0721), // Bogotá, Colombia
      title: 'Select Your Business Location',
      confirmButtonText: 'CONFIRM',
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location selected: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Example 2: Navigate without initial location (will use current location)
  Future<void> _openLocationPickerCurrentLocation() async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Select Location',
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  /// Example 3: Use the selected location in your business logic
  void _saveLocationToDatabase() {
    if (_selectedLocation != null) {
      // Here you would typically save to your database
      print(
        'Saving location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
      );

      // Example: Update user profile with location
      // await userRepository.updateLocation(
      //   latitude: _selectedLocation!.latitude,
      //   longitude: _selectedLocation!.longitude,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display selected location
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_selectedLocation != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'No location selected yet',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Button examples
            ElevatedButton.icon(
              onPressed: _openLocationPickerFullPage,
              icon: const Icon(Icons.location_on),
              label: const Text('Pick Location (with initial position)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _openLocationPickerCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Pick Location (current location)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed:
                  _selectedLocation != null ? _saveLocationToDatabase : null,
              icon: const Icon(Icons.save),
              label: const Text('Save Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Usage instructions
            const Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to use:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Tap any "Pick Location" button above\n'
                          '2. The map will open with a centered person pin\n'
                          '3. Move the map to position the pin on your desired location\n'
                          '4. Use the "My Location" button to center on current GPS position\n'
                          '5. Tap "Confirm Location" to select\n'
                          '6. The coordinates will be displayed above\n'
                          '7. Use "Save Location" to persist the data',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
