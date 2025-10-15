import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/data/models/location_service_model.dart';

import 'editable_service_card.dart';
import 'location_services_form_controller.dart';

class UpsertLocationServices extends StatelessWidget {
  const UpsertLocationServices({
    super.key,
    required this.controller,
  });

  final LocationServicesFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.editableServices.isEmpty) {
        return const Text('No hay servicios. Agrega servicios para comenzar.');
      }

      final bySub = controller.servicesBySubcategory;
      final List<Widget> children = [];

      bySub.forEach((subId, list) {
        final categoryName = controller.categoryNameForSubcategory(subId);
        final subName = controller.subcategoryName(subId);

        children.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$categoryName · $subName',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () => controller.addService(subcategoryId: subId),
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'Añadir servicio',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
        ]);

        for (final s in list) {
          children.add(
            EditableServiceCard(
              controller: controller,
              service: s,
            ),
          );
        }
        children.add(const SizedBox(height: 8));
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }
}

