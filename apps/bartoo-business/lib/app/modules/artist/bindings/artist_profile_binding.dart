import 'package:get/get.dart';

import '../controllers/artist_profile_controller.dart';

class ArtistProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistProfileController>(() => ArtistProfileController());
  }
}
