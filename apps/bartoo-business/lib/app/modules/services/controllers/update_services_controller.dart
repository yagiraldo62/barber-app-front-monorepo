import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/modules/services/providers/artist_location_service_provider.dart';
import 'package:utils/log.dart';
import 'package:get/get.dart';
import 'package:bartoo/app/modules/services/classes/location_services_item_model.dart';

import 'package:core/data/models/category/category_model.dart';

class UpdateServicesController extends GetxController {
  final ArtistLocationServiceProvider _serviceProvider =
      Get.find<ArtistLocationServiceProvider>();
  final CategoryProvider _categoryProvider = Get.find<CategoryProvider>();

  final RxList<LocationServicesItemModel> locationServices =
      <LocationServicesItemModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isCategoriesLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoriesErrorMessage = ''.obs;

  String artistId = '';
  String locationId = '';

  // Parameter to indicate if this is a creation flow
  bool isCreation = false;

  @override
  void onInit() {
    super.onInit();
    // Obtener parámetros de la ruta
    artistId = Get.parameters['artist_id'] ?? '';
    locationId = Get.parameters['artist_location_id'] ?? '';
    isCreation = Get.parameters['isCreation'] == 'true';

    if (artistId.isNotEmpty && locationId.isNotEmpty) {
      fetchCategories();
      fetchLocationServices();
    }
  }

  Future<void> fetchCategories() async {
    if (isCategoriesLoading.value) return;

    isCategoriesLoading.value = true;
    categoriesErrorMessage.value = '';

    try {
      final result = await _categoryProvider.getCategories(
        withSubcategories: true,
      );
      if (result != null) {
        categories.clear();
        categories.addAll(result);
      }
    } catch (e) {
      categoriesErrorMessage.value =
          'Error al cargar las categorías: ${e.toString()}';
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> fetchLocationServices() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final services = await _serviceProvider.getLocationServices(
        artistId,
        locationId,
        withNonSelected: true,
      );
      locationServices.clear();
      // locationServices.addAll(services);
    } catch (e) {
      errorMessage.value = 'Error al cargar los servicios: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateService(LocationServicesItemModel service) {
    final index = locationServices.indexWhere(
      (item) => item.serviceId == service.serviceId,
    );
    if (index != -1) {
      locationServices[index] = service;
    }
  }

  // Función para actualizar un solo campo de un servicio
  void updateServiceField(String serviceId, String field, dynamic value) {
    final index = locationServices.indexWhere(
      (item) => item.serviceId == serviceId,
    );
    if (index != -1) {
      // En lugar de crear un nuevo objeto, modificamos solo la propiedad específica
      switch (field) {
        case 'name':
          locationServices[index] = locationServices[index].copyWith(
            name: value as String,
          );
          break;
        case 'duration':
          locationServices[index] = locationServices[index].copyWith(
            duration: value as int,
          );
          break;
        case 'price':
          locationServices[index] = locationServices[index].copyWith(
            price: value as double,
          );
          break;
        case 'isActive':
          locationServices[index] = locationServices[index].copyWith(
            isActive: value as bool,
          );
          break;
      }
    }
  }

  // Método para agrupar servicios por categoría
  Map<String, List<LocationServicesItemModel>> getServicesByCategory() {
    Map<String, List<LocationServicesItemModel>> servicesByCategory = {};

    for (var service in locationServices) {
      if (servicesByCategory.containsKey(service.categoryId)) {
        servicesByCategory[service.categoryId]!.add(service);
      } else {
        servicesByCategory[service.categoryId] = [service];
      }
    }

    return servicesByCategory;
  }

  // Método para obtener el nombre de la categoría por ID
  String getCategoryName(String categoryId) {
    // Buscar en las subcategorías de todas las categorías principales
    for (var category in categories) {
      for (var subcategory in category.subcategories) {
        if (subcategory.id == categoryId) {
          return subcategory.name ?? 'Sin nombre';
        }
      }
    }
    return 'Categoría desconocida';
  }

  // Método para agregar un nuevo servicio a una categoría específica
  void addNewService(String categoryId) {
    // Generar un ID temporal único para el nuevo servicio
    final tempId = 'new_${DateTime.now().millisecondsSinceEpoch}';

    // Crear una nueva instancia de servicio con valores predeterminados
    final newService = LocationServicesItemModel(
      artistLocationId: locationId,
      serviceId: tempId,
      name: 'Nuevo servicio',
      duration: 30, // Duración predeterminada: 30 minutos
      price: 0.0, // Precio predeterminado: 0
      categoryId: categoryId,
      isActive: true,
      isNewService: true, // Marcamos como nuevo para identificarlo al guardar
    );

    // Añadir el nuevo servicio a la lista
    locationServices.add(newService);
  }

  // Método para guardar todos los cambios realizados
  Future<bool> saveAllChanges() async {
    try {
      final filteredServices =
          locationServices
              .where(
                (service) =>
                    (service.isNewService && service.isActive) ||
                    service.id != null ||
                    service.isActive,
              )
              .toList();

      for (var service in filteredServices) {
        Log('Service: ${service.toJson()}');
      }

      // await _serviceProvider.upsertLocationServices(
      //   artistId,
      //   locationId,
      //   filteredServices,
      // );

      await fetchLocationServices();

      return true;
    } catch (e) {
      return false;
    }
  }
}
