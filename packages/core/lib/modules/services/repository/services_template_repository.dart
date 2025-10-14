import 'package:core/data/models/services_template_model.dart';
import 'package:core/modules/services/providers/services_template_provider.dart';
import 'package:utils/log.dart';
import 'package:utils/snackbars.dart';
import 'package:get/get.dart';

class ServicesTemplateRepository {
  final ServicesTemplateProvider servicesTemplateProvider =
      Get.find<ServicesTemplateProvider>();

  /// Get services templates by category IDs
  ///
  /// [categoryIds] - List of category IDs to filter templates
  ///
  /// Returns a list of [ServicesTemplateModel] or an empty list if error occurs
  Future<List<ServicesTemplateModel>> getServiceTemplatesByCategories(
    List<String> categoryIds,
  ) async {
    try {
      Log('getServiceTemplatesByCategories: $categoryIds');

      final response = await servicesTemplateProvider
          .getServiceTemplatesByCategories(categoryIds);

      Log('Response: $response');

      return response ?? [];
    } catch (e) {
      Log('Error in getServiceTemplatesByCategories: $e');

      Snackbars.error(
        title: "Error al cargar plantillas de servicios",
        message: e.toString(),
      );

      return <ServicesTemplateModel>[];
    }
  }
}
