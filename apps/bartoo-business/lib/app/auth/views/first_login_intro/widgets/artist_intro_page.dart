import 'package:bartoo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistIntroPage extends StatelessWidget {
  const ArtistIntroPage({super.key});

  static String title = '¿Eres Barbero?';

  static Widget image = Image.asset("/images/artist_intro.png", width: 300);

  @override
  Widget build(BuildContext context) {
    // Get.find<BusinessAuthGuardController>();

    return Column(
      children: [
        const Text(
          "¿Prestas servicios de barberia mediante citas y/o domicilios?",
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.createProfile);
          },
          child: const Text("Continuar como Barbero"),
        ),
      ],
    );
  }
}
