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

enum ProfileFormStep { workMode, name, title, description, categories, photo }

class ProfileFormController extends GetxController
    implements StepperFormController<Rx<ProfileFormStep>> {
  final ProfileModel? currentProfile;
  final bool isCreation;
  final void Function(ProfileModel)? onSavedCallback;
  final ScrollController? scrollController;
  final void Function(bool)?
  onIndependentArtistToggled; // Optional override when creation completes

  ProfileFormController(
    this.currentProfile,
    this.isCreation, {
    this.onSavedCallback,
    this.scrollController,
    this.onIndependentArtistToggled,
  }) {
    Log('Current Profile= ${currentProfile?.toJson()}');
  }

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
  final isIndependentArtist = Rx<bool?>(null);
  final animationsComplete = false.obs;

  @override
  final currentStep = Rx<ProfileFormStep>(ProfileFormStep.workMode);
  @override
  void onInit() {
    super.onInit();

    // Get user type from router arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final userType = arguments?['userType'] as String?;

    currentStep.value = ProfileFormStep.name;

    // Set type based on route argument
    if (userType == 'artist') {
      profileType.value = ProfileType.artist;
      isIndependentArtist.value = currentProfile?.independentArtist;
      // Defer callback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onIndependentArtistToggled?.call(isIndependentArtist.value ?? false);
      });
      currentStep.value = ProfileFormStep.workMode;
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

      // After categories are loaded and the UI expands, try scrolling down
      scrollToBottom();
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
          currentProfile!.id!,
          nameController.text,
          selectedCategoriesId,
          titleController.text,
          descriptionController.text,
          image.value,
          independentArtist: isIndependentArtist.value,
        );
      } else {
        artist = await profileRepository.create(
          name: nameController.text,
          categoriesId: selectedCategoriesId,
          type: profileType.value,
          title: titleController.text,
          description: descriptionController.text,
          image: image.value,
          independentArtist: isIndependentArtist.value,
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

    if (profileTypeType == ProfileType.artist) {
      isIndependentArtist.value = false;
      onIndependentArtistToggled?.call(false);
      currentStep.value = ProfileFormStep.workMode;
    } else {
      currentStep.value = ProfileFormStep.name;
    }
  }

  void setWorkMode(bool independent) {
    isIndependentArtist.value = independent;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onIndependentArtistToggled?.call(independent);
    });
    // Enable button after selection
    Future.delayed(const Duration(milliseconds: 100), () {
      animationsComplete.value = true;
    });
  }

  void onAnimationsComplete() {
    animationsComplete.value = true;
  }

  @override
  void nextStep() {
    switch (currentStep.value) {
      case ProfileFormStep.workMode:
        if (isIndependentArtist.value == null) {
          Snackbars.error(
            message: 'Debes seleccionar una modalidad de trabajo',
          );
          return;
        }
        // Reset animation state when successfully moving to next step
        animationsComplete.value = false;
        currentStep.value = ProfileFormStep.name;
        break;
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

  void scrollToBottom() {
    Log('Attempting to scroll to bottom $isCreation');
    // Only auto-scroll during creation flows
    if (scrollController == null || !isCreation) return;

    void attemptScroll(int attempt) {
      if (!(scrollController?.hasClients ?? false)) {
        if (attempt >= 5) return;
        Future.delayed(const Duration(milliseconds: 80), () {
          attemptScroll(attempt + 1);
        });
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = scrollController;
        if (controller == null || !(controller.hasClients)) return;

        final position = controller.position;
        final target = position.maxScrollExtent;

        controller.animateTo(
          target,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      });
    }

    attemptScroll(0);
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
