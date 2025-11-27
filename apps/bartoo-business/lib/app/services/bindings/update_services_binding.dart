import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/modules/services/providers/artist_location_service_provider.dart';
import 'package:get/get.dart';

import '../controllers/update_services_controller.dart';

class UpdateServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryProvider>(() => CategoryProvider());
    Get.lazyPut<ArtistLocationServiceProvider>(
      () => ArtistLocationServiceProvider(),
    );
    Get.lazyPut<UpdateServicesController>(() => UpdateServicesController());
  }
}
