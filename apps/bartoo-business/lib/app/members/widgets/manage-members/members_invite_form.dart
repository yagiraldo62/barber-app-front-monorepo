import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/input/phone_number_input.dart';
import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/input/dropdown_field.dart';
import 'package:utils/log.dart';
import '../../controllers/members_invite_controller.dart';

class MembersInviteForm extends StatelessWidget {
  final MembersInviteController controller;
  const MembersInviteForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 0,
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Invitar o agregar miembro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _LocationSelector(controller: controller)),
                    const SizedBox(width: 12),
                    Expanded(child: _RoleSelector(controller: controller)),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonTextField(
                        labelText: 'Nombre del receptor',
                        hintText: 'Ej: Juan Pérez',
                        onChanged: (v) => controller.receptorName.value = v,
                      ),
                      const SizedBox(height: 16),
                      PhoneNumberInput(
                        labelText: 'Teléfono',
                        onChanged:
                            (e164) => controller.phoneNumber.value = e164,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('¿Es artista?'),
                          const SizedBox(width: 12),
                          Obx(
                            () => Switch(
                              value: controller.isArtist.value,
                              onChanged: (v) => controller.isArtist.value = v,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Enviar por:'),
                          const SizedBox(width: 12),
                          ToggleButtons(
                            isSelected: [
                              controller.sendBy.value == 'sms',
                              controller.sendBy.value == 'whatsapp',
                            ],
                            onPressed: (i) {
                              controller.sendBy.value =
                                  i == 0 ? 'sms' : 'whatsapp';
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('SMS'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('WhatsApp'),
                              ),
                            ],
                          ),
                          const Spacer(),
                          AppButton(
                            label: 'Invitar',
                            isLoading: controller.isLoading.value,
                            onPressed: () async {
                              try {
                                await controller.inviteByPhone();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invitación enviada'),
                                    ),
                                  );
                                }
                              } catch (_) {}
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Marca "¿Es artista?" si el miembro que invitas es un artista en tu sistema.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  final MembersInviteController controller;
  const _LocationSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final locations = controller.availableLocationMembers;
      final currentValue = controller.selectedLocationId.value;

      final currentLocation = locations.firstWhereOrNull(
        (loc) => loc.id == currentValue,
      );

      Log(
        'Building LocationSelector with locations: ${locations.map((loc) => loc.toJson())} and currentValue: $currentValue',
      );

      return locations.isNotEmpty && currentLocation != null
          ? CommonDropdownField<String?>(
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
                final locationName =
                    loc.name.isNotEmpty ? loc.name : 'Sin nombre';
                return DropdownMenuItem(
                  value: loc.id,
                  child: Text(locationName),
                );
              }),
            ],
            onChanged: (v) {
              controller.changeLocationSelection(v);
            },
          )
          : SizedBox(
            height: 48,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No hay ubicaciones disponibles. Invitando al nivel de organización.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
    });
  }
}

class _RoleSelector extends StatelessWidget {
  final MembersInviteController controller;
  const _RoleSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOrganization = controller.selectedLocationId.value == "org";
      final roles =
          isOrganization ? const ['super-admin'] : const ['member', 'manager'];

      return CommonDropdownField<String>(
        labelText: 'Rol',
        value:
            controller.selectedRole.value.isEmpty
                ? roles.first
                : controller.selectedRole.value,
        items:
            roles
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r.replaceAll('_', ' ').toUpperCase()),
                  ),
                )
                .toList(),
        onChanged:
            isOrganization
                ? null // Disable dropdown for organization
                : (v) {
                  if (v != null) controller.selectedRole.value = v;
                },
        enabled: !isOrganization,
      );
    });
  }
}
