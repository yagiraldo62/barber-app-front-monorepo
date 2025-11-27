import 'package:bartoo/app/appointments/controllers/schedule_appointment_controller.dart';
import 'package:bartoo/app/appointments/widgets/schedule_appointment/schedule_appointment_input.dart';
import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moment_dart/moment_dart.dart';

class ScheduleAppointment extends StatelessWidget {
  final ScheduleAppointmentController scheduleAppointmentController =
      Get.find<ScheduleAppointmentController>();

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  final Function onAppointmentScheduled;
  final AppointmentModel appointment;
  final bool isClient;

  ScheduleAppointment({
    super.key,
    this.isClient = false,
    required this.onAppointmentScheduled,
    required this.appointment,
  }) {
    // // if the logged in user is an artist, replace the appointment´s artist with the value of the logged in artist
    // if (authController.selectedScope.value != null) {
    //   appointment.artist = authController.selectedScope.value;
    // }

    // if the appointment is new, init
    appointment.startTime ??= Moment.now();

    scheduleAppointmentController.initializeAppointment(
      appointment,
      onAppointmentScheduled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Obx(
          () => Container(
            padding: EdgeInsets.all(
              scheduleAppointmentController.loadingArtistAvailabilty.value
                  ? 30
                  : 10,
            ),
            child: Obx(
              () =>
                  scheduleAppointmentController.loadingArtistAvailabilty.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          // !isClient && appointment.client != null
                          //     ? ClientCard(user: appointment.client!)
                          //     : ArtistCard(artist: appointment.artist!),
                          const SizedBox(height: 8),
                          ScheduleAppointmentInput(),
                          const SizedBox(height: 20),
                          Obx(
                            () => Column(
                              children:
                                  scheduleAppointmentController.categories
                                      .map(
                                        (category) => Column(
                                          children: [
                                            Text(category.name ?? ""),
                                            // Row(
                                            //   children: selectableEntityButtonList<
                                            //     LocationServiceModel
                                            //   >(
                                            //     category.services,
                                            //     (
                                            //       List<LocationServiceModel>
                                            //       services,
                                            //     ) =>
                                            //         scheduleAppointmentController
                                            //             .updateCategoryServices(
                                            //               category.id,
                                            //               services,
                                            //             ),
                                            //     atLeatOne:
                                            //         scheduleAppointmentController
                                            //             .onlyOneServiceSelected
                                            //             .value,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      const Text("Duración"),
                                      Obx(
                                        () => Text(
                                          "${scheduleAppointmentController.duration.value}",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      const Text("Precio"),
                                      Obx(
                                        () => Text(
                                          "${scheduleAppointmentController.price.value}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed:
                                    scheduleAppointmentController
                                        .saveAppointment,
                                child: const Text("Guardar"),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
