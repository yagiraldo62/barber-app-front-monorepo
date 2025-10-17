import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_page.dart';

/// Helper function to navigate to the location picker page
///
/// Usage example:
/// ```dart
/// final selectedLocation = await navigateToLocationPicker(
///   context: context,
///   initialLocation: LatLng(4.7110, -74.0721),
///   title: 'Select Your Business Location',
/// );
///
/// if (selectedLocation != null) {
///   print('Selected: ${selectedLocation.latitude}, ${selectedLocation.longitude}');
/// }
/// ```
Future<LatLng?> navigateToLocationPicker({
  required BuildContext context,
  LatLng? initialLocation,
  String? title,
  String? confirmButtonText,
}) async {
  final result = await Navigator.of(context).push<LatLng>(
    MaterialPageRoute(
      builder:
          (context) => LocationPickerPage(
            initialLocation: initialLocation,
            title: title,
            confirmButtonText: confirmButtonText,
            onLocationSelected: (LatLng location) {
              // The location is passed back via pop
            },
          ),
    ),
  );

  return result;
}

/// Alternative widget-based approach for inline usage
class LocationPickerWidget extends StatefulWidget {
  /// Initial location to center the map on
  final LatLng? initialLocation;

  /// Callback function when location is selected
  final Function(LatLng selectedLocation) onLocationSelected;

  /// Optional: Widget height
  final double? height;

  /// Optional: Whether to show confirm button (default: true)
  final bool showConfirmButton;

  const LocationPickerWidget({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.height,
    this.showConfirmButton = true,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _handleLocationUpdate(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 400,
      child: Stack(
        children: [
          LocationPickerPage(
            initialLocation: widget.initialLocation,
            onLocationSelected: _handleLocationUpdate,
          ),
          if (widget.showConfirmButton)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
