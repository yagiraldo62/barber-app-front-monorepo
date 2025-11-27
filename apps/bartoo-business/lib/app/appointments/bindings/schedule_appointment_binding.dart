import 'package:bartoo/app/appointments/controllers/schedule_appointment_controller.dart';
import 'package:get/get.dart';

class ScheduleAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AppointmentRepository>(
    //   () => AppointmentRepository(),
    // );

    // Shedule Appointment Controller
    Get.lazyPut<ScheduleAppointmentController>(
      () => ScheduleAppointmentController(),
    );
  }
}
