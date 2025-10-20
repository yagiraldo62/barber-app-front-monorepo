import 'package:flutter/material.dart';
import 'package:ui/widgets/input/text_field.dart';

import 'package:core/data/models/location_service_model.dart';
import 'package:ui/widgets/input/duration_selector.dart';
import '../../../controllers/location_services_form_controller.dart';

class EditableServiceCard extends StatelessWidget {
  const EditableServiceCard({
    super.key,
    required this.controller,
    required this.service,
    this.showHeader = false,
    this.header,
  });

  final LocationServicesFormController controller;
  final LocationServiceModel service;
  final bool showHeader;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: service.name);
    final priceController = TextEditingController(
      text: service.price.toString(),
    );

    return Card(
      // margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader && header != null) ...[
                  header!,
                  const SizedBox(height: 8),
                ],
                CommonTextField(
                  controller: nameController,
                  labelText: 'Nombre del servicio',
                  onBlur:
                      (value) =>
                          controller.updateServiceField(service, name: value),
                ),

                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: DurationSelector(
                        initialValue: service.duration,
                        labelText: 'Duración',
                        onChanged:
                            (value) => controller.updateServiceField(
                              service,
                              duration: value,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CommonTextField(
                        controller: priceController,
                        labelText: 'Precio',
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.attach_money),
                        onBlur: (value) {
                          final p = value != null ? num.tryParse(value) : null;
                          controller.updateServiceField(service, price: p ?? 0);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 15,
            child: IconButton(
              tooltip: 'Eliminar',
              onPressed: () => controller.removeService(service),
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
