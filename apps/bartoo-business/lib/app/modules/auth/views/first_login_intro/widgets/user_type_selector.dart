import 'package:core/modules/auth/controllers/auth_intro_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/typography/typography.dart';

class UserTypeConfig {
  final UserType type;
  final String title;
  final String description;
  final List<String>? features;

  const UserTypeConfig({
    required this.type,
    required this.title,
    required this.description,
    this.features,
  });
}

class UserTypeSelector extends StatelessWidget {
  final Function(UserType) onTypeSelected;
  final Rx<UserType?> selectedType;

  const UserTypeSelector({
    super.key,
    required this.onTypeSelected,
    required this.selectedType,
  });

  static const List<UserTypeConfig> userTypes = [
    UserTypeConfig(
      type: UserType.artist,
      title: 'Soy Artista',
      description: 'Profesional independiente o afiliado a un negocio',
    ),
    UserTypeConfig(
      type: UserType.organization,
      title: 'Administro una Organización',
      description: 'Negocio de estética, belleza o bienestar',
      features: [
        'Liquidador',
        'Visualización en el mapa',
        'Los clientes se quedan contigo aun si se van los artistas',
        'Puedes tener el rol de artista administrador',
      ],
    ),
    UserTypeConfig(
      type: UserType.member,
      title: 'Soy Colaborador',
      description: 'Administra una organización como colaborador',
    ),
    UserTypeConfig(
      type: UserType.client,
      title: 'Soy Cliente',
      description: 'Busco servicios de estética, belleza y bienestar',
      features: ['Reserva citas online', 'Encuentra profesionales cerca de ti'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          userTypes.map((config) {
            return Column(
              children: [
                Obx(
                  () => InkWell(
                    onTap: () => onTypeSelected(config.type),
                    child: Card(
                      elevation: selectedType.value == config.type ? 8 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              selectedType.value == config.type
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                          width: selectedType.value == config.type ? 2 : 1,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Typography(
                              config.title,
                              variation: TypographyVariation.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Typography(
                              config.description,
                              variation: TypographyVariation.bodySmall,
                              color: Theme.of(context).colorScheme.onSurface
                                  .withAlpha((0.6 * 255).round()),
                            ),
                            if (config.features != null) ...[
                              const SizedBox(height: 8),
                              ...config.features!.map(
                                (feature) => Typography(
                                  '• $feature',
                                  variation: TypographyVariation.bodySmall,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withAlpha((0.6 * 255).round()),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (config != userTypes.last) const SizedBox(height: 16),
              ],
            );
          }).toList(),
    );
  }
}
