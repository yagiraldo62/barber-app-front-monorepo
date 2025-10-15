import 'package:get/get.dart';
import 'package:core/modules/services/providers/services_template_provider.dart';
import 'package:core/modules/services/repository/services_template_repository.dart';
import 'package:core/data/models/services_template_model.dart';
import 'package:core/data/models/services_template_item_model.dart';
import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/location_service_model.dart';

class ServicesTemplatesSelectionController extends GetxController {
  ServicesTemplatesSelectionController({
    required this.categoryIds,
    required this.locationId,
    this.categories = const <CategoryModel>[],
  });

  final List<String> categoryIds;
  final String locationId;
  final List<CategoryModel> categories;

  late final ServicesTemplateRepository _servicesTemplateRepository;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<ServicesTemplateModel> templates = <ServicesTemplateModel>[].obs;
  final RxSet<String> selectedTemplateIds = <String>{}.obs;

  final Map<String, CategoryModel> _subcategoryById = {};
  final Map<String, String> _subcategoryParentCategoryId = {};
  final Map<String, CategoryModel> _categoryById = {};

  @override
  void onInit() {
    super.onInit();
    _ensureDependencies();
    _buildLookups();
    loadTemplates();
  }

  void _ensureDependencies() {
    if (!Get.isRegistered<ServicesTemplateProvider>()) {
      Get.put(ServicesTemplateProvider());
    }
    if (!Get.isRegistered<ServicesTemplateRepository>()) {
      Get.put(ServicesTemplateRepository());
    }
    _servicesTemplateRepository = Get.find<ServicesTemplateRepository>();
  }

  void _buildLookups() {
    _subcategoryById.clear();
    _subcategoryParentCategoryId.clear();
    _categoryById.clear();
    for (final cat in categories) {
      _categoryById[cat.id] = cat;
      for (final sub in cat.subcategories) {
        _subcategoryById[sub.id] = sub;
        _subcategoryParentCategoryId[sub.id] = cat.id;
      }
    }
  }

  String categoryNameForSubcategory(String subcategoryId) {
    final parentId = _subcategoryParentCategoryId[subcategoryId];
    final c = parentId != null ? _categoryById[parentId] : null;
    return c?.name ?? 'Categoría';
  }

  String subcategoryName(String subcategoryId) {
    return _subcategoryById[subcategoryId]?.name ?? 'Subcategoría';
  }

  Future<void> loadTemplates() async {
    if (categoryIds.isEmpty) {
      templates.clear();
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final fetched = await _servicesTemplateRepository
          .getServiceTemplatesByCategories(categoryIds);
      templates.assignAll(fetched);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTemplateSelection(String templateId) {
    if (selectedTemplateIds.contains(templateId)) {
      selectedTemplateIds.remove(templateId);
    } else {
      selectedTemplateIds.add(templateId);
    }
  }

  List<ServicesTemplateItemModel> get selectedTemplateItems {
    final items = <ServicesTemplateItemModel>[];
    for (final t in templates) {
      if (selectedTemplateIds.contains(t.id)) {
        items.addAll(t.items);
      }
    }
    return items;
  }

  List<LocationServiceModel> buildServicesFromSelected() {
    final items = selectedTemplateItems;
    return items
        .map(
          (i) => LocationServiceModel(
            id: '',
            locationId: locationId,
            name: i.name,
            duration: i.duration,
            price: i.price,
            isActive: true,
            subcategoryId: i.subcategoryId,
          ),
        )
        .toList();
  }
}

