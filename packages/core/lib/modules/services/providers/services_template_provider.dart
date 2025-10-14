import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/services_template_model.dart';

class ServicesTemplateProvider extends BaseProvider {
  final String _baseUrl = '/services/templates';

  /// Get services templates by category IDs
  ///
  /// [categoryIds] - List of category IDs to filter templates
  ///
  /// Example:
  /// ```dart
  /// final templates = await getServiceTemplatesByCategories([
  ///   'b3af2441-2795-4bc6-b8ed-1e552c309913',
  ///   '2ae30679-3b51-4981-a6c8-55fd06ba17f9'
  /// ]);
  /// ```
  Future<List<ServicesTemplateModel>?> getServiceTemplatesByCategories(
    List<String> categoryIds,
  ) async {
    if (categoryIds.isEmpty) {
      return [];
    }

    final categoryIdsString = categoryIds.join(',');
    final response = await get('$_baseUrl/by-categories/$categoryIdsString');

    if (response.body?["ok"] == true) {
      return ServicesTemplateModel.listFromJson(response.body["data"]);
    }

    return null;
  }
}
