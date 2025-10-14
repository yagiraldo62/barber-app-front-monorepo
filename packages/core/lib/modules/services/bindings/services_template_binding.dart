import 'package:core/modules/services/providers/services_template_provider.dart';
import 'package:core/modules/services/repository/services_template_repository.dart';
import 'package:get/get.dart';

class ServicesTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesTemplateProvider>(() => ServicesTemplateProvider());
    Get.lazyPut<ServicesTemplateRepository>(() => ServicesTemplateRepository());
  }
}
