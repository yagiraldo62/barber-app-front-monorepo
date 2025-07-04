import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:get/get.dart';
import 'package:bartoo/app/modules/locations/controllers/forms/artist_location_form_controller.dart';

class CreateLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistLocationProvider>(() => ArtistLocationProvider());
    Get.lazyPut<ArtistLocationFormController>(
      () => ArtistLocationFormController(),
    );
  }
}
