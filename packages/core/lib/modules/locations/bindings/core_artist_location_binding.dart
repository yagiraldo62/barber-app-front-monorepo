import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:get/get.dart';

class CoreArtistLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistLocationProvider>(() => ArtistLocationProvider());
  }
}
