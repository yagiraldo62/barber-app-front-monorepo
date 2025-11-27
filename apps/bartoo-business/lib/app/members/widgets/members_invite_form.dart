import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/input/phone_number_input.dart';
import 'package:ui/widgets/input/text_field.dart';
import '../controllers/members_invite_controller.dart';
import '../../shared/presentation/widgets/selectors/location_selector.dart';
import '../../shared/presentation/widgets/selectors/role_selector.dart';

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
                    Expanded(child: LocationSelector(controller: controller)),
                    const SizedBox(width: 12),
                    Expanded(child: RoleSelector(controller: controller)),
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
