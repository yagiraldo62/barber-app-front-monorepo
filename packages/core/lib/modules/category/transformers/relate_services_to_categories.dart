import 'package:core/data/models/artists/artist_location_service_model.dart';
import 'package:core/data/models/category/category_model.dart';

/// Relate services to categories
/// - relate services to the categories
/// - set the first category as selected
/// - set the first service of the first category as selected
List<CategoryModel> relateServicesToCategories(
  List<CategoryModel>? categories,
  List<ArtistLocationServiceModel>? services,
) =>
    (categories ?? []).asMap().entries.map((category) {
      // set the first category as selected
      category.value.selected = category.key == 0;

      // relate the services to the categories
      (services ?? []).map((artistService) {
        artistService.items.map((service) {
          if (service.categoryId == category.value.id) {
            bool serviceAlreadyInCategory =
                category.value.services.indexWhere((s) => s.id == service.id) !=
                -1;
            if (!serviceAlreadyInCategory) {
              category.value.services.add(service);
            }
          }
        }).toList();
      }).toList();

      category.value.services =
          category.value.services.asMap().entries.map((service) {
            // set the first service of the first category as selected
            service.value.selected = service.key == 0 && category.key == 0;
            return service.value;
          }).toList();

      return category.value;
    }).toList();
