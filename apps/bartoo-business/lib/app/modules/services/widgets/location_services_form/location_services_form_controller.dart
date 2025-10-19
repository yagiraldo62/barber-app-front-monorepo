import 'package:get/get.dart';
import 'package:core/modules/services/providers/location_service_provider.dart';
import 'package:core/modules/services/repository/location_service_repository.dart';
import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/data/models/location_service_model.dart';
import 'package:core/data/models/category_model.dart';

class LocationServicesFormController extends GetxController {
  LocationServicesFormController({
    required this.profileId,
    required this.locationId,
    required this.servicesUp,
  });

  final String profileId;
  final String locationId;
  final bool servicesUp;

  // Dependencies (lazy ensure)
  late final LocationServiceRepository _locationServiceRepository;
  late final CategoryProvider _categoryProvider;

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString error = ''.obs;

  // Data
  final RxList<LocationServiceModel> existingServices =
      <LocationServiceModel>[].obs;
  final RxList<LocationServiceModel> editableServices =
      <LocationServiceModel>[].obs;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // Search
  final RxString searchQuery = ''.obs;

  // Newly added service for highlighting
  final Rx<LocationServiceModel?> newlyAddedService = Rx<LocationServiceModel?>(
    null,
  );

  // Lookup maps
  final Map<String, CategoryModel> _categoryById = {};
  final Map<String, CategoryModel> _subcategoryById = {};
  final Map<String, String> _subcategoryParentCategoryId = {};

  bool get hasExistingServices => existingServices.isNotEmpty;
  bool get isSetupFlow => !hasExistingServices && !servicesUp;

  @override
  void onInit() {
    super.onInit();
    _ensureDependencies();
    _bootstrap();
  }

  void _ensureDependencies() {
    if (!Get.isRegistered<LocationServiceProvider>()) {
      Get.put(LocationServiceProvider());
    }
    if (!Get.isRegistered<LocationServiceRepository>()) {
      Get.put(LocationServiceRepository());
    }
    if (!Get.isRegistered<CategoryProvider>()) {
      Get.put(CategoryProvider());
    }

    _locationServiceRepository = Get.find<LocationServiceRepository>();
    _categoryProvider = Get.find<CategoryProvider>();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    error.value = '';

    try {
      await Future.wait([_loadCategories(), _loadExistingServices()]);

      // Initialize editable list from existing if present
      if (existingServices.isNotEmpty) {
        editableServices.assignAll(existingServices);
      }

      // Templates flow handled by ServicesTemplatesSelectionController
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadExistingServices() async {
    final result = await _locationServiceRepository.getLocationServices(
      profileId,
      locationId,
    );
    existingServices.assignAll(result);
  }

  Future<void> _loadCategories() async {
    final result = await _categoryProvider.getCategories(
      withSubcategories: true,
    );
    if (result != null) {
      categories.assignAll(result);
      _buildLookups(result);
    }
  }

  void _buildLookups(List<CategoryModel> list) {
    _categoryById.clear();
    _subcategoryById.clear();
    _subcategoryParentCategoryId.clear();

    for (final cat in list) {
      if (cat.id.isNotEmpty) {
        _categoryById[cat.id] = cat;
      }
      for (final sub in cat.subcategories) {
        if (sub.id.isNotEmpty) {
          _subcategoryById[sub.id] = sub;
          _subcategoryParentCategoryId[sub.id] = cat.id;
        }
      }
    }
  }

  String categoryNameForSubcategory(String subcategoryId) {
    final parentId = _subcategoryParentCategoryId[subcategoryId];
    final category = parentId != null ? _categoryById[parentId] : null;
    return category?.name ?? 'CategorÃ­a';
  }

  String subcategoryName(String subcategoryId) {
    return _subcategoryById[subcategoryId]?.name ?? 'SubcategorÃ­a';
  }

  void addService({required String subcategoryId}) {
    final newService = LocationServiceModel(
      id: '',
      locationId: locationId,
      name: 'Nuevo servicio',
      duration: 30,
      price: 0,
      isActive: true,
      subcategoryId: subcategoryId,
    );
    editableServices.add(newService);
    newlyAddedService.value = newService;

    // Clear the newly added service after a delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (newlyAddedService.value == newService) {
        newlyAddedService.value = null;
      }
    });
  }

  void removeService(LocationServiceModel service) {
    // For new ones (without id), remove; for existing, toggle inactive
    if (service.id.isEmpty) {
      editableServices.remove(service);
    } else {
      final idx = editableServices.indexOf(service);
      if (idx >= 0) {
        editableServices[idx] = LocationServiceModel(
          id: service.id,
          locationId: service.locationId,
          name: service.name,
          description: service.description,
          duration: service.duration,
          price: service.price,
          isActive: false,
          subcategoryId: service.subcategoryId,
          createdAt: service.createdAt,
          updatedAt: service.updatedAt,
          deletedAt: service.deletedAt,
        );
      }
    }
  }

  void updateServiceField(
    LocationServiceModel service, {
    String? name,
    int? duration,
    num? price,
    bool? isActive,
  }) {
    final idx = editableServices.indexOf(service);
    if (idx < 0) return;
    final s = editableServices[idx];
    editableServices[idx] = LocationServiceModel(
      id: s.id,
      locationId: s.locationId,
      name: name ?? s.name,
      description: s.description,
      duration: duration ?? s.duration,
      price: price ?? s.price,
      isActive: isActive ?? s.isActive,
      subcategoryId: s.subcategoryId,
      createdAt: s.createdAt,
      updatedAt: s.updatedAt,
      deletedAt: s.deletedAt,
    );
  }

  Map<String, List<LocationServiceModel>> get servicesBySubcategory {
    final map = <String, List<LocationServiceModel>>{};
    final query = searchQuery.value.toLowerCase().trim();

    for (final s in editableServices) {
      // Filter by search query if present
      if (query.isNotEmpty) {
        final matchesName = s.name.toLowerCase().contains(query);
        final matchesPrice = s.price.toString().contains(query);
        final matchesDuration = s.duration.toString().contains(query);

        if ((!matchesName && !matchesPrice && !matchesDuration) ||
            !s.isActive) {
          continue;
        }
      }

      map.putIfAbsent(s.subcategoryId, () => []).add(s);
    }
    return map;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<List<LocationServiceModel>> save() async {
    isSaving.value = true;
    try {
      final payload =
          editableServices.map((s) {
            return <String, dynamic>{
              if (s.id.isNotEmpty) 'id': s.id,
              'name': s.name,
              'duration': s.duration,
              'price': s.price,
              'subcategory_id': s.subcategoryId,
              'is_active': s.isActive,
              if (s.description != null) 'description': s.description,
            };
          }).toList();

      final updated = await _locationServiceRepository.upsertLocationServices(
        profileId,
        locationId,
        payload,
      );
      existingServices.assignAll(updated);
      editableServices.assignAll(updated);
      return updated;
    } finally {
      isSaving.value = false;
    }
  }
}
