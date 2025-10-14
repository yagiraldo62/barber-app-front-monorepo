import 'package:core/modules/services/providers/location_service_provider.dart';
import 'package:core/modules/services/repository/location_service_repository.dart';
import 'package:get/get.dart';

class LocationServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationServiceProvider>(() => LocationServiceProvider());
    Get.lazyPut<LocationServiceRepository>(() => LocationServiceRepository());
  }
}
