import 'package:bartoo/app/locations/controllers/update_location_controller.dart';
import 'package:core/modules/auth/repository/auth_repository.dart';
import 'package:core/modules/auth/repository/user_repository.dart';
import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:get/get.dart';

class UpdateLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateLocationController>(() => UpdateLocationController());
    Get.lazyPut<ArtistLocationProvider>(() => ArtistLocationProvider());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
