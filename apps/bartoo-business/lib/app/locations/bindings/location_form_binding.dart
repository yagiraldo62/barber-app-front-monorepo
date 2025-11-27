import 'package:core/modules/locations/providers/artist_location_provider.dart';
import 'package:get/get.dart';

class LocationFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistLocationProvider>(() => ArtistLocationProvider());
  }
}
