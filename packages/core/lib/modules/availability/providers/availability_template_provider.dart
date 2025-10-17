import 'package:base/providers/base_provider.dart';
import 'package:core/data/models/availability_template_model.dart';

class AvailabilityTemplateProvider extends BaseProvider {
  Future<List<AvailabilityTemplateModel>?> getAvailabilityTemplates() async {
    final response = await get('/availability-templates');

    if (response.body?["ok"] == true) {
      return AvailabilityTemplateModel.listFromJson(response.body["data"]);
    }

    return null;
  }
}
