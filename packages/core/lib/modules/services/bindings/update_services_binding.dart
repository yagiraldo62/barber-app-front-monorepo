import 'package:core/modules/category/providers/category_provider.dart';
import 'package:core/modules/services/providers/artist_location_service_provider.dart';
import 'package:get/get.dart';

class CoreUpdateServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryProvider>(() => CategoryProvider());
    Get.lazyPut<ArtistLocationServiceProvider>(
      () => ArtistLocationServiceProvider(),
    );
  }
}
