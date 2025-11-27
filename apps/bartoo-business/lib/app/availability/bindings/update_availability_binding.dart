import 'package:bartoo/app/availability/controllers/update_availability_controller.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/availability/providers/location_availability_provider.dart';
import 'package:get/get.dart';

class UpdateAvailabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateAvailabilityController>(
      () => UpdateAvailabilityController(),
    );
    Get.lazyPut<LocationAvailabilityProvider>(
      () => LocationAvailabilityProvider(),
    );
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
