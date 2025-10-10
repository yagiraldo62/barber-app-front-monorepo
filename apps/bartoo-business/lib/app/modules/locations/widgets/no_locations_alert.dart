import 'package:bartoo/app/modules/auth/controllers/business_auth_controller.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/modules/auth/classes/selected_scope.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoLocationsAlert extends StatelessWidget {
  final VoidCallback? onCreateLocation;

  final BusinessAuthController authController =
      Get.find<BusinessAuthController>();

  NoLocationsAlert({super.key, this.onCreateLocation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "No tienes ubicaciones configuradas",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Para gestionar tus citas, primero debes crear al menos una ubicación donde atenderás a tus clientes",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  onCreateLocation ??
                  () => Get.toNamed(
                    Routes.CREATE_LOCATION.replaceAll(
                      ':artist_id',
                      (authController.selectedScope.value as ProfileScope?)
                              ?.profile
                              .id
                              .toString() ??
                          '',
                    ),
                  ),
              child: const Text("Crear mi primera ubicación"),
            ),
          ],
        ),
      ),
    );
  }
}
