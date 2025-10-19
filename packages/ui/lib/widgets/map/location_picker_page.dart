import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ui/widgets/map/base_themed_map.dart';

/// A page widget that allows users to select a location on a map
/// by moving the map and placing a centered pin marker
class LocationPickerPage extends StatefulWidget {
  /// Initial location to center the map on
  final LatLng? initialLocation;

  /// Callback function when location is selected
  final Function(LatLng selectedLocation) onLocationSelected;

  /// Optional: Custom title for the app bar
  final String? title;

  /// Optional: Custom confirm button text
  final String? confirmButtonText;

  const LocationPickerPage({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.title,
    this.confirmButtonText,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late MapController _mapController;
  LatLng? _currentCenter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeLocation();
  }

  /// Initialize the map with either provided location or current location
  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      setState(() {
        _currentCenter = widget.initialLocation;
        _isLoading = false;
      });
    } else {
      await _getCurrentLocation();
    }
  }

  /// Get user's current location
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setDefaultLocation();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      _setDefaultLocation();
    }
  }

  /// Set a default location if current location cannot be obtained
  void _setDefaultLocation() {
    setState(() {
      // Default to a generic location (you can change this)
      _currentCenter = const LatLng(4.7110, -74.0721); // Bogotá, Colombia
      _isLoading = false;
    });
  }

  /// Handle the map position change
  void _onMapPositionChanged(MapCamera position, bool hasGesture) {
    if (hasGesture) {
      setState(() {
        _currentCenter = position.center;
      });
    }
  }

  /// Confirm the selected location
  void _confirmLocation() {
    if (_currentCenter != null) {
      widget.onLocationSelected(_currentCenter!);
      Navigator.of(context).pop(_currentCenter);
    }
  }

  /// Center the map on current GPS location
  Future<void> _centerOnCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(newLocation, 17.0);

      setState(() {
        _currentCenter = newLocation;
      });
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not get current location'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? 'Select Location')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Select Location'),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: Text(
              widget.confirmButtonText ?? 'CONFIRM',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Base themed map widget
          BaseThemedMap(
            mapController: _mapController,
            center: _currentCenter!,
            zoom: 17.0,
            minZoom: 5.0,
            maxZoom: 18.0,
            onPositionChanged: _onMapPositionChanged,
          ),

          // Center pin marker (person icon) - Offset upwards by 50% of icon size
          Center(
            child: Transform.translate(
              offset: const Offset(
                0,
                -25,
              ), // 50% del tamaño del icono (50px / 2 = 25px)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pin with shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_pin_circle,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Helper text at the top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Move the map to place the pin on your desired location',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _centerOnCurrentLocation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // Confirm button at the bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.confirmButtonText ?? 'Confirm Location',
                style: const TextStyle(
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

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
