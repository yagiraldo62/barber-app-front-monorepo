import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/shared/location_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';
import 'package:utils/snackbars.dart';
import 'package:utils/log.dart';
import 'package:utils/geolocation/map_utils.dart';

/// Enum to track the steps in the location form
enum LocationFormStep { name, address, region, location }

class LocationFormController extends GetxController
    implements StepperFormController<Rx<LocationFormStep>> {
  final ArtistLocationProvider provider = Get.find<ArtistLocationProvider>();
  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  // Current location data
  LocationModel? currentLocation;
  final location = Rx<Map<String, double>?>(null);

  bool isCreation;
  final void Function(LocationModel)? onSavedCallback;

  // Current step tracker
  @override
  final Rx<LocationFormStep> currentStep = LocationFormStep.name.obs;
  // Loading state for the form
  final RxBool loading = false.obs;
  final RxBool animationsComplete = false.obs;

  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // Focus nodes for form fields
  final FocusNode nameFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode address2Focus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();

  LocationFormController({
    this.currentLocation,
    this.isCreation = true,
    this.onSavedCallback,
  }) {
    _initializeControllers();
  }

  void _initializeControllers() async {
    // Initialize animation state
    animationsComplete.value = false;

    if (currentLocation != null) {
      // Editing existing location
      nameController.text = currentLocation!.name;
      addressController.text = currentLocation!.address ?? '';
      address2Controller.text = currentLocation!.address2 ?? '';
      cityController.text = currentLocation!.city;
      stateController.text = currentLocation!.state;
      countryController.text = currentLocation!.country;
    } else if (isCreation) {
      // Creating new location - get current location and populate fields
      await _initializeFromCurrentLocation();
    }
  }

  /// Initialize location fields from user's current location
  Future<void> _initializeFromCurrentLocation() async {
    try {
      final locationData = await getCurrentLocationWithAddress();

      Log('Location Dart: $locationData');

      if (locationData != null) {
        // Populate city, state, and country from current location
        if (locationData['city'] != null) {
          cityController.text = locationData['city'] as String;
        }
        if (locationData['state'] != null) {
          stateController.text = locationData['state'] as String;
        }
        if (locationData['country'] != null) {
          countryController.text = locationData['country'] as String;
        }

        // Optionally set the coordinates
        if (locationData['latitude'] != null &&
            locationData['longitude'] != null) {
          location.value = {
            'latitude': locationData['latitude'] as double,
            'longitude': locationData['longitude'] as double,
          };
        }
      }
    } catch (e) {
      // Silently fail - user can still manually enter location
      print('Failed to get current location: $e');
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    nameController.dispose();
    addressController.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();

    nameFocus.dispose();
    addressFocus.dispose();
    address2Focus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    countryFocus.dispose();

    super.onClose();
  }

  @override
  bool get isLoading => loading.value;

  void onAnimationsComplete() {
    animationsComplete.value = true;
  }

  @override
  void nextStep() {
    switch (currentStep.value) {
      case LocationFormStep.name:
        if (_validateNameStep()) {
          // Reset animation state when successfully moving to next step
          animationsComplete.value = false;
          currentStep.value = LocationFormStep.address;
        }
        break;
      case LocationFormStep.address:
        if (_validateAddressStep()) {
          // Reset animation state when successfully moving to next step
          animationsComplete.value = false;
          currentStep.value = LocationFormStep.region;
        }
        break;
      case LocationFormStep.region:
        if (_validateRegionStep()) {
          // Reset animation state when successfully moving to next step
          animationsComplete.value = false;
          currentStep.value = LocationFormStep.location;
        }
        break;
      case LocationFormStep.location:
        _submitForm();
        break;
    }
  }

  bool _validateNameStep() {
    if (nameController.text.trim().isEmpty) {
      // Show validation error
      Get.snackbar(
        'Error de validación',
        'Debes ingresar un nombre para la ubicación',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  bool _validateAddressStep() {
    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debes ingresar una dirección principal',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  bool _validateRegionStep() {
    if (cityController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty ||
        countryController.text.trim().isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debes completar todos los campos de ciudad, estado y país',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  void setLocation(Map<String, double> newLocation) {
    location.value = newLocation;
  }

  /// Get address information from coordinates and populate the form fields
  Future<void> getAddressFromLocation(Map<String, double> coordinates) async {
    try {
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];

      if (latitude == null || longitude == null) {
        throw Exception('Invalid coordinates');
      }

      final addressComponents = await getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      if (addressComponents != null) {
        // Populate address fields if empty
        if (addressComponents.street != null &&
            addressController.text.isEmpty) {
          addressController.text = addressComponents.street!;
        }

        // Populate city, state, country
        if (addressComponents.city != null) {
          cityController.text = addressComponents.city!;
        }
        if (addressComponents.state != null) {
          stateController.text = addressComponents.state!;
        }
        if (addressComponents.country != null) {
          countryController.text = addressComponents.country!;
        }

        Snackbars.success(message: 'Dirección obtenida de la ubicación');
      } else {
        Snackbars.error(
          message: 'No se pudo obtener la dirección de la ubicación',
        );
      }
    } catch (e) {
      Snackbars.error(
        message: 'Error al obtener la dirección: ${e.toString()}',
      );
    }
  }

  Future<void> _submitForm() async {
    try {
      if (loading.value) return;
      loading.value = true;

      final scope = authController.selectedScope.value;
      if (scope == null) throw Exception('No scope selected');

      late String profileId;

      if (scope is ProfileScope) {
        profileId = scope.profile.id;
      } else if (scope is LocationMemberScope) {
        if (scope.locationMember.organization == null) {
          throw Exception('No organization found in scope');
        }
        profileId = scope.locationMember.organization!.id;
      } else {
        throw Exception('Invalid scope type for creating location');
      }

      final result = await provider.createLocation(
        profileId,
        nameController.text,
        addressController.text,
        location.value,
        address2: address2Controller.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
      );

      if (result == null) throw Exception('Error creating location');

      if (onSavedCallback != null) {
        onSavedCallback!(result);
      } else {
        await onSavedDefault(result);
      }

      loading.value = false;
      Snackbars.success(message: 'Ubicación creada exitosamente');
    } catch (e) {
      Snackbars.error(message: e.toString());
      loading.value = false;
    }
  }

  Future<void> onSavedDefault(LocationModel result) async {
    Get.back();
  }
}
