import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/category/category_model.dart';

class CategoryProvider extends BaseProvider {
  Future<List<CategoryModel>?> getCategories({
    bool withSubcategories = false,
  }) async {
    final response = await get(
      '/categories${withSubcategories ? '?subcategories=true' : ''}',
    );

    print(response.body["data"]);

    if (response.body?["ok"] == true) {
      return CategoryModel.listFromJson(response.body["data"]);
    }

    return null;
  }
}
