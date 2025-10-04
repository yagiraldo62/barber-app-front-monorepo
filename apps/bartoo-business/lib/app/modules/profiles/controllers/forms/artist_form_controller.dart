import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:core/modules/artist/repository/artist_repository.dart';
import 'package:core/data/models/artists/artist_model.dart';
import 'package:core/data/models/category/category_model.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/category/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';
import 'package:utils/log.dart';
import 'package:utils/snackbars.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ArtistFormStep { name, title, description, categories, photo }

class ArtistFormController extends GetxController
    implements StepperFormController<Rx<ArtistFormStep>> {
  final ArtistModel? currentArtist;
  final bool isCreation;

  ArtistFormController(this.currentArtist, this.isCreation);

  final ArtistRepository artistRepository = Get.find<ArtistRepository>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final UserRepository userRepository = Get.find<UserRepository>();
  final CategoryRepository categoryRepository = Get.find<CategoryRepository>();

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final nameFocus = FocusNode();
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();

  final image = Rx<XFile?>(null);
  final categories = Rx<List<CategoryModel>>([]);
  final loadingCategories = false.obs;
  final loading = false.obs;
  final typeSelected = false.obs;
  final isArtist = true.obs;
  final animationsComplete = false.obs;

  @override
  final currentStep = Rx<ArtistFormStep>(ArtistFormStep.name);
  @override
  void onInit() {
    super.onInit();

    // Get user type from router arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final userType = arguments?['userType'] as String?;

    // Set type based on route argument
    if (userType == 'artist') {
      isArtist.value = true;
    } else if (userType == 'organization') {
      isArtist.value = false;
    } else {
      // Default to artist if no argument provided
      isArtist.value = true;
    }
    typeSelected.value = true;

    // Initialize animation state
    animationsComplete.value = false;

    if (currentArtist != null) {
      nameController.text = currentArtist!.name;
      titleController.text = currentArtist!.title;
      descriptionController.text = currentArtist!.description;
      currentStep.value = ArtistFormStep.name;
    }

    loadCategories();
  }

  void setImage(XFile? img) async {
    image.value = img;
  }

  Future<void> loadCategories() async {
    try {
      loadingCategories.value = true;
      categories.value =
          ((await categoryRepository.getCategories()) ?? [])
              .asMap()
              .entries
              .map((category) {
                category.value.selected = category.key == 0;
                return category.value;
              })
              .toList();
      loadingCategories.value = false;
    } catch (e) {
      loadingCategories.value = false;
    }
  }

  void setCategories(List<CategoryModel> newCategories) =>
      categories.value = newCategories;

  List<String> getSelectedCategoriesId() =>
      categories.value
          .where((category) => category.selected == true)
          .map((category) => category.id)
          .toList();

  void upsertArtist() async {
    try {
      if (loading.value) {
        return;
      }

      if (authController.user.value == null) {
        throw Exception('User not found');
      }

      loading.value = true;

      List<String> selectedCategoriesId = getSelectedCategoriesId();

      ArtistModel? artist;

      if (currentArtist != null) {
        artist = await artistRepository.update(
          currentArtist!.id,
          nameController.text,
          selectedCategoriesId,
          titleController.text,
          descriptionController.text,
          image.value,
        );
      } else {
        artist = await artistRepository.create(
          nameController.text,
          selectedCategoriesId,
          titleController.text,
          descriptionController.text,
          image.value,
        );
      }

      if (artist == null) {
        throw Exception('Error creating artist');
      }

      await onSaved(artist);

      loading.value = false;

      Snackbars.success();
    } catch (e) {
      loading.value = false;

      Log(e);
      Snackbars.error(message: e.toString());
    }

    return null;
  }

  Future<void> onSaved(ArtistModel artist) async {
    if (authController.user.value!.isFirstLogin) {
      await authRepository.updateFirstLogin(false);
      authController.user.value!.isFirstLogin = false;
    }

    artist.owner = null;
    authController.user.value!.upsertArtist(artist);

    await authRepository.setAuthUser(authController.user.value);
    await authRepository.setSelectedArtist(artist);

    authController.selectedArtist.value = artist;
    Get.offAndToNamed(dotenv.env['HOME_ROUTE'] ?? '/home');
  }

  void setType(bool isArtistType) {
    isArtist.value = isArtistType;
    typeSelected.value = true;
    currentStep.value = ArtistFormStep.name;
  }

  void onAnimationsComplete() {
    animationsComplete.value = true;
  }

  @override
  void nextStep() {
    switch (currentStep.value) {
      case ArtistFormStep.name:
        if (nameController.text.isEmpty) {
          Snackbars.error(message: 'El nombre comercial es requerido');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ArtistFormStep.title;
        break;
      case ArtistFormStep.title:
        if (titleController.text.isEmpty) {
          Snackbars.error(message: 'El título es requerido');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ArtistFormStep.description;
        break;
      case ArtistFormStep.description:
        if (descriptionController.text.isEmpty) {
          Snackbars.error(message: 'La descripción es requerida');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ArtistFormStep.categories;
        break;
      case ArtistFormStep.categories:
        if (getSelectedCategoriesId().isEmpty) {
          Snackbars.error(message: 'Debes seleccionar al menos una categoría');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ArtistFormStep.photo;
        break;
      case ArtistFormStep.photo:
        upsertArtist();
        break;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    nameFocus.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.onClose();
  }

  @override
  bool get isLoading => loading.value;
}
