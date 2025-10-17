import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/widgets/map/location_picker_helper.dart';

/// Quick integration examples for common use cases

// ============================================================================
// Example 1: Business Registration - Select Business Location
// ============================================================================
class BusinessRegistrationForm extends StatefulWidget {
  const BusinessRegistrationForm({super.key});

  @override
  State<BusinessRegistrationForm> createState() =>
      _BusinessRegistrationFormState();
}

class _BusinessRegistrationFormState extends State<BusinessRegistrationForm> {
  LatLng? _businessLocation;

  Future<void> _selectBusinessLocation() async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Select Business Location',
      confirmButtonText: 'CONFIRM',
    );

    if (location != null) {
      setState(() {
        _businessLocation = location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Other form fields...
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Business Location'),
          subtitle:
              _businessLocation != null
                  ? Text(
                    '${_businessLocation!.latitude.toStringAsFixed(4)}, '
                    '${_businessLocation!.longitude.toStringAsFixed(4)}',
                  )
                  : const Text('Not selected'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: _selectBusinessLocation,
        ),

        // More form fields...
      ],
    );
  }
}

// ============================================================================
// Example 2: User Profile - Update Home Address
// ============================================================================
class UpdateAddressScreen extends StatefulWidget {
  final LatLng? currentLocation;

  const UpdateAddressScreen({super.key, this.currentLocation});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.currentLocation;
  }

  Future<void> _updateLocation() async {
    final location = await navigateToLocationPicker(
      context: context,
      initialLocation: _selectedLocation,
      title: 'Update Your Address',
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });

      // Save to database
      await _saveLocationToProfile(location);
    }
  }

  Future<void> _saveLocationToProfile(LatLng location) async {
    // Your save logic here
    // await userRepository.updateLocation(location);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Address')),
      body: Center(
        child: ElevatedButton(
          onPressed: _updateLocation,
          child: const Text('Select Location on Map'),
        ),
      ),
    );
  }
}

// ============================================================================
// Example 3: Service Request - Select Service Location
// ============================================================================
class ServiceRequestForm extends StatefulWidget {
  const ServiceRequestForm({super.key});

  @override
  State<ServiceRequestForm> createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  LatLng? _serviceLocation;

  Future<void> _selectServiceLocation() async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Where do you need the service?',
      confirmButtonText: 'SET LOCATION',
    );

    if (location != null) {
      setState(() {
        _serviceLocation = location;
      });
    }
  }

  void _submitServiceRequest() {
    if (_serviceLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service location')),
      );
      return;
    }

    // Submit the service request with location
    print(
      'Service requested at: ${_serviceLocation!.latitude}, ${_serviceLocation!.longitude}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              Icons.location_on,
              color: _serviceLocation != null ? Colors.green : Colors.grey,
            ),
            title: const Text('Service Location'),
            subtitle:
                _serviceLocation != null
                    ? const Text('Location selected')
                    : const Text('Tap to select location'),
            trailing: const Icon(Icons.edit),
            onTap: _selectServiceLocation,
          ),
        ),

        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: _serviceLocation != null ? _submitServiceRequest : null,
          child: const Text('Submit Request'),
        ),
      ],
    );
  }
}

// ============================================================================
// Example 4: Delivery Address - Multiple Addresses
// ============================================================================
class AddressManager extends StatefulWidget {
  const AddressManager({super.key});

  @override
  State<AddressManager> createState() => _AddressManagerState();
}

class _AddressManagerState extends State<AddressManager> {
  final List<Map<String, dynamic>> _savedAddresses = [];

  Future<void> _addNewAddress() async {
    final location = await navigateToLocationPicker(
      context: context,
      title: 'Add New Address',
      confirmButtonText: 'SAVE',
    );

    if (location != null) {
      // Show dialog to add address label
      final label = await _showLabelDialog();

      if (label != null) {
        setState(() {
          _savedAddresses.add({
            'label': label,
            'location': location,
            'timestamp': DateTime.now(),
          });
        });
      }
    }
  }

  Future<String?> _showLabelDialog() async {
    String? label;
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Address Label'),
            content: TextField(
              decoration: const InputDecoration(hintText: 'e.g., Home, Work'),
              onChanged: (value) => label = value,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, label),
                child: const Text('SAVE'),
              ),
            ],
          ),
    );
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses')),
      body: ListView.builder(
        itemCount: _savedAddresses.length,
        itemBuilder: (context, index) {
          final address = _savedAddresses[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(address['label']),
            subtitle: Text(
              '${address['location'].latitude.toStringAsFixed(4)}, '
              '${address['location'].longitude.toStringAsFixed(4)}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAddress,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================================
// Example 5: Simple Button to Open Picker
// ============================================================================
class QuickLocationButton extends StatelessWidget {
  final Function(LatLng) onLocationSelected;
  final LatLng? initialLocation;

  const QuickLocationButton({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final location = await navigateToLocationPicker(
          context: context,
          initialLocation: initialLocation,
        );

        if (location != null) {
          onLocationSelected(location);
        }
      },
      icon: const Icon(Icons.map),
      label: const Text('Select on Map'),
    );
  }
}
