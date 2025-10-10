import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/artist_location_model.dart';
import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';
import 'package:utils/snackbars.dart';

/// Enum to track the steps in the location form
enum LocationFormStep { name, address, region, location }

class ArtistLocationFormController extends GetxController
    implements StepperFormController<Rx<LocationFormStep>> {
  final ArtistLocationProvider provider = Get.find<ArtistLocationProvider>();
  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  // Current location data
  ArtistLocationModel? currentLocation;
  final location = Rx<Map<String, double>?>(null);

  bool isCreation;

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

  ArtistLocationFormController({this.currentLocation, this.isCreation = true}) {
    _initializeControllers();
  }
  void _initializeControllers() {
    // Initialize animation state
    animationsComplete.value = false;
    if (currentLocation != null) {
      nameController.text = currentLocation!.name;
      addressController.text = currentLocation!.address ?? '';
      address2Controller.text = currentLocation!.address2 ?? '';
      cityController.text = currentLocation!.city ?? '';
      stateController.text = currentLocation!.state ?? '';
      countryController.text = currentLocation!.country ?? '';
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

  Future<void> _submitForm() async {
    try {
      if (loading.value) return;
      loading.value = true;

      final artist = authController.selectedScope.value;
      if (artist == null) throw Exception('No artist selected');

      // final result = await provider.createLocation(
      //   artist.id,
      //   nameController.text,
      //   addressController.text,
      //   location.value,
      //   address2: address2Controller.text,
      //   city: cityController.text,
      //   state: stateController.text,
      //   country: countryController.text,
      // );

      // if (result == null) throw Exception('Error creating location');

      // artist.locations ??= [];
      // artist.locations!.add(result);

      Get.back();
      Snackbars.success(message: 'Ubicación creada exitosamente');
    } catch (e) {
      Snackbars.error(message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}
