import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/data/models/profile_model.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/profile/repository/profile_repository.dart';
import 'package:core/modules/category/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/widgets/form/stepper_form_fields.dart';
import 'package:utils/log.dart';
import 'package:utils/snackbars.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ProfileFormStep { name, title, description, categories, photo }

class ProfileFormController extends GetxController
    implements StepperFormController<Rx<ProfileFormStep>> {
  final ProfileModel? currentProfile;
  final bool isCreation;
  final void Function(ProfileModel)? onSavedCallback;

  ProfileFormController(
    this.currentProfile,
    this.isCreation, {
    this.onSavedCallback,
  });

  final ProfileRepository profileRepository = Get.find<ProfileRepository>();
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
  final profileType = ProfileType.organization.obs;
  final animationsComplete = false.obs;

  @override
  final currentStep = Rx<ProfileFormStep>(ProfileFormStep.name);
  @override
  void onInit() {
    super.onInit();

    // Get user type from router arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final userType = arguments?['userType'] as String?;

    // Set type based on route argument
    if (userType == 'artist') {
      profileType.value = ProfileType.artist;
    } else if (userType == 'organization') {
      profileType.value = ProfileType.organization;
    } else {
      // Default to organization if no argument provided
      profileType.value = ProfileType.organization;
    }
    typeSelected.value = true;

    // Initialize animation state
    animationsComplete.value = false;

    if (currentProfile != null) {
      nameController.text = currentProfile!.name;
      titleController.text = currentProfile!.title ?? '';
      descriptionController.text = currentProfile!.description ?? '';
      currentStep.value = ProfileFormStep.name;
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

  void upsertProfile() async {
    try {
      if (loading.value) {
        return;
      }

      if (authController.user.value == null) {
        throw Exception('User not found');
      }

      loading.value = true;

      List<String> selectedCategoriesId = getSelectedCategoriesId();

      ProfileModel? artist;

      if (currentProfile != null) {
        artist = await profileRepository.update(
          currentProfile!.id,
          nameController.text,
          selectedCategoriesId,
          titleController.text,
          descriptionController.text,
          image.value,
        );
      } else {
        artist = await profileRepository.create(
          name: nameController.text,
          categoriesId: selectedCategoriesId,
          type: profileType.value,
          title: titleController.text,
          description: descriptionController.text,
          image: image.value,
        );
      }

      if (artist == null) {
        throw Exception('Error creating artist');
      }

      if (onSavedCallback != null) {
        onSavedCallback!(artist);
      } else {
        await onSavedDefault(artist);
      }

      loading.value = false;

      Snackbars.success();
    } catch (e) {
      loading.value = false;

      Log(e);
      Snackbars.error(message: e.toString());
    }

    return null;
  }

  Future<void> onSavedDefault(ProfileModel profile) async {
    if (authController.user.value!.isFirstLogin) {
      await authRepository.updateFirstLogin(false, true);
      authController.user.value!.isFirstLogin = false;
      authController.user.value!.isOrganizationMember = true;
    }

    await authController.refreshUser();
    await authController.setAuthDefaultScope(
      preferredScope: ProfileScope(profile),
    );

    Get.offAndToNamed(Routes.ARTIST_HOME);
  }

  void setType(ProfileType profileTypeType) {
    profileType.value = profileTypeType;
    typeSelected.value = true;
    currentStep.value = ProfileFormStep.name;
  }

  void onAnimationsComplete() {
    animationsComplete.value = true;
  }

  @override
  void nextStep() {
    switch (currentStep.value) {
      case ProfileFormStep.name:
        if (nameController.text.isEmpty) {
          Snackbars.error(message: 'El nombre comercial es requerido');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ProfileFormStep.title;
        break;
      case ProfileFormStep.title:
        if (titleController.text.isEmpty) {
          Snackbars.error(message: 'El título es requerido');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ProfileFormStep.description;
        break;
      case ProfileFormStep.description:
        if (descriptionController.text.isEmpty) {
          Snackbars.error(message: 'La descripción es requerida');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ProfileFormStep.categories;
        break;
      case ProfileFormStep.categories:
        if (getSelectedCategoriesId().isEmpty) {
          Snackbars.error(message: 'Debes seleccionar al menos una categoría');
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ProfileFormStep.photo;
        break;
      case ProfileFormStep.photo:
        upsertProfile();
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
