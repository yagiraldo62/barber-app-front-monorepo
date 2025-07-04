import 'package:core/modules/category/providers/category_provider.dart';
import 'package:utils/log.dart';
import 'package:utils/snackbars.dart';
import 'package:core/data/models/category/category_model.dart';
import 'package:get/get.dart';

class CategoryRepository {
  final CategoryProvider categoryRepository = Get.find<CategoryProvider>();
  Future<List<CategoryModel>?> getCategories() async {
    try {
      Log('getCategories');

      final response = await categoryRepository.getCategories();
      Log(response);
      return response;
    } catch (e) {
      Log(e);

      Snackbars.error(
        title: "Error al cargar categorias",
        message: e.toString(),
      );

      return <CategoryModel>[];
    }
  }
}
