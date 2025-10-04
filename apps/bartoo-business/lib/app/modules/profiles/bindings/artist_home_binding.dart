import 'package:bartoo/app/modules/profiles/controllers/artist_appointments_menu_controller.dart';
import 'package:bartoo/app/modules/profiles/controllers/artist_bottom_navigation_controller.dart';
import 'package:core/modules/appointments/repository/appointment_repository.dart';
import 'package:get/get.dart';

class ArtistHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentRepository>(() => AppointmentRepository());

    // Artist Bottom Navigation Controller
    Get.lazyPut<ArtistBottomNavigationController>(
      () => ArtistBottomNavigationController(),
    );

    // Artist Appointments Menu Controller (Active - History)
    Get.lazyPut<ArtistAppointmentsMenuController>(
      () => ArtistAppointmentsMenuController(),
    );
  }
}
