import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/input/dropdown_field.dart';
import '../../../../members/controllers/members_invite_controller.dart';

class LocationSelector extends StatelessWidget {
  final MembersInviteController controller;
  const LocationSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final locations = controller.availableLocationMembers;
      final currentValue = controller.selectedLocationId.value;

      return CommonDropdownField<String?>(
        labelText: 'Ubicación',
        hintText: 'Selecciona una ubicación',
        value: currentValue.isEmpty ? null : currentValue,
        items: [
          const DropdownMenuItem(
            value: 'org',
            child: Text('Organización (Full access)'),
          ),
          ...locations.map((loc) {
            // loc is LocationModel
            final locationName = loc.name.isNotEmpty ? loc.name : 'Sin nombre';
            return DropdownMenuItem(value: loc.id, child: Text(locationName));
          }),
        ],
        onChanged: (v) {
          controller.changeLocationSelection(v);
        },
      );
    });
  }
}
