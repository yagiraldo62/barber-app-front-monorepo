import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';

import '../classes/location_services_item_model.dart';
import '../controllers/update_services_controller.dart';
import 'duration_selector.dart';

class ServiceCard extends StatelessWidget {
  final LocationServicesItemModel service;
  final UpdateServicesController controller;

  const ServiceCard({
    super.key,
    required this.service,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Crear los controladores pero manteniendo una referencia clara
    final nameController = TextEditingController(text: service.name);
    final priceController = TextEditingController(
      text: service.price.toString(),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    controller: nameController,
                    labelText: 'Nombre del servicio',
                    onBlur: (value) {
                      controller.updateServiceField(
                        service.serviceId,
                        'name',
                        value,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: service.isActive,
                  onChanged: (value) {
                    controller.updateServiceField(
                      service.serviceId,
                      'isActive',
                      value,
                    );
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DurationSelector(
                    initialValue: service.duration,
                    labelText: 'Duración',
                    onChanged: (value) {
                      controller.updateServiceField(
                        service.serviceId,
                        'duration',
                        value,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonTextField(
                    controller: priceController,
                    labelText: 'Precio',
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                    onBlur: (value) {
                      final price =
                          value != null ? double.tryParse(value) : 0.0;
                      controller.updateServiceField(
                        service.serviceId,
                        'price',
                        price,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
