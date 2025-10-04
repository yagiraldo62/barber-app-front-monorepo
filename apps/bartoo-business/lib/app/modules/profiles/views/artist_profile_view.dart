import 'package:bartoo/app/modules/appointments/widgets/schedule_appointment/schedule_appointment_input.dart';
import 'package:flutter/material.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/map/map_box_view.dart';
import 'package:get/get.dart';

import '../controllers/artist_profile_controller.dart';

class ArtistProfileView extends GetView<ArtistProfileController> {
  const ArtistProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      back: true,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Stack(
              children: [
                Hero(
                  tag: "baber-profile-1",
                  child: AspectRatio(
                    aspectRatio: 1 / 0.7,
                    child: Image(
                      image: AssetImage("assets/images/b1.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // AspectRatio(
                //   aspectRatio: 1 / 0.7,
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: ArtistCard(
                //       image: false,
                //       transparent: true,
                //     ),
                //   ),
                // )
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TabBar(
                            physics: NeverScrollableScrollPhysics(),
                            tabs: [
                              Tab(
                                icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 10),
                                    Text("Agendar"),
                                  ],
                                ),
                              ),
                              Tab(
                                icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.apps),
                                    SizedBox(width: 10),
                                    Text("Portafolio"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            ScheduleAppointmentInput(),
                            const SizedBox(height: 5),
                            const MapBoxView(),
                          ],
                        ),
                        const Icon(Icons.directions_transit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
