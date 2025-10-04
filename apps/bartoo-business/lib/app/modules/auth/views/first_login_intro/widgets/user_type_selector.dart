import 'package:core/modules/auth/controllers/auth_intro_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/typography/typography.dart';

class UserTypeSelector extends StatelessWidget {
  final Function(UserType) onTypeSelected;
  final Rx<UserType?> selectedType;

  const UserTypeSelector({
    super.key,
    required this.onTypeSelected,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Artist Option
        Obx(
          () => InkWell(
            onTap: () => onTypeSelected(UserType.artist),
            child: Card(
              elevation: selectedType.value == UserType.artist ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      selectedType.value == UserType.artist
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                  width: selectedType.value == UserType.artist ? 2 : 1,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Typography(
                      'Soy Artista',
                      variation: TypographyVariation.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Typography(
                      'Profesional independiente o afiliado a un negocio',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16), // Organization Manager Option
        Obx(
          () => InkWell(
            onTap: () => onTypeSelected(UserType.organization),
            child: Card(
              elevation: selectedType.value == UserType.organization ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      selectedType.value == UserType.organization
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                  width: selectedType.value == UserType.organization ? 2 : 1,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Typography(
                      'Administro una Organización',
                      variation: TypographyVariation.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Typography(
                      'Negocio de estética, belleza o bienestar',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    const SizedBox(height: 8),
                    Typography(
                      '• Liquidador',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    Typography(
                      '• Visualización en el mapa',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    Typography(
                      '• Los clientes se quedan contigo aun si se van los artistas',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    Typography(
                      '• Puedes tener el rol de artista administrador',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16), // Client Option
        Obx(
          () => InkWell(
            onTap: () => onTypeSelected(UserType.client),
            child: Card(
              elevation: selectedType.value == UserType.client ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      selectedType.value == UserType.client
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                  width: selectedType.value == UserType.client ? 2 : 1,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Typography(
                      'Soy Cliente',
                      variation: TypographyVariation.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Typography(
                      'Busco servicios de estética, belleza y bienestar',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    const SizedBox(height: 8),
                    Typography(
                      '• Reserva citas online',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                    Typography(
                      '• Encuentra profesionales cerca de ti',
                      variation: TypographyVariation.bodySmall,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
