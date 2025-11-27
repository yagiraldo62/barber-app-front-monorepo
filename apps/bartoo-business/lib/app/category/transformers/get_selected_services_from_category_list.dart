import 'package:core/data/models/category_model.dart';
import 'package:core/data/models/location_service_model.dart';

List<LocationServiceModel> getSelectedServicesFromcategoryList(
  List<CategoryModel>? categories,
) => (categories ?? []).fold(
  <LocationServiceModel>[],
  (services, category) => [
    ...services,
    // ...category.services.where((service) => service.selected ?? false),
  ],
);
