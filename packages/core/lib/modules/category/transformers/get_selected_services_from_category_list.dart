import 'package:core/data/models/category/category_model.dart';
import 'package:core/data/models/category/category_service_model.dart';

List<CategoryServiceModel> getSelectedServicesFromcategoryList(
  List<CategoryModel>? categories,
) => (categories ?? []).fold(
  <CategoryServiceModel>[],
  (services, category) => [
    ...services,
    ...category.services.where((service) => service.selected ?? false),
  ],
);
