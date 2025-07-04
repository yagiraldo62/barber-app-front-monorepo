import 'package:bartoo/app/modules/appointments/controllers/artist/artist_appointments_controller.dart';
import 'package:get/get.dart';

class ArtistAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveArtistAppointmentsController>(
      () => ActiveArtistAppointmentsController(),
    );

    Get.lazyPut<ArtistAppointmentsHistoryController>(
      () => ArtistAppointmentsHistoryController(),
    );
  }
}
