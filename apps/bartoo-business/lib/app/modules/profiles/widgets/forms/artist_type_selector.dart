import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/typography/typography.dart';

class ArtistTypeSelector extends StatelessWidget {
  final VoidCallback onArtistSelected;
  final VoidCallback onBusinessSelected;
  final RxBool typeSelected;
  final RxBool isArtist;

  const ArtistTypeSelector({
    super.key,
    required this.onArtistSelected,
    required this.onBusinessSelected,
    required this.typeSelected,
    required this.isArtist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => InkWell(
            onTap: onArtistSelected,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color:
                    isArtist.value && typeSelected.value
                        ? Theme.of(context).highlightColor
                        : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Typography(
                    'Soy Artista:',
                    variation: TypographyVariation.titleMedium,
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
        const SizedBox(height: 16),
        Obx(
          () => InkWell(
            onTap: onBusinessSelected,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color:
                    !isArtist.value && typeSelected.value
                        ? Theme.of(context).highlightColor
                        : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Typography(
                    'Administro un Negocio:',
                    variation: TypographyVariation.titleMedium,
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
                    '• Visualizacion en el mapa',
                    variation: TypographyVariation.bodySmall,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
                  Typography(
                    '• Los clientes de tu negocio se quedan contigo aun si se van los artistas',
                    variation: TypographyVariation.bodySmall,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
                  Typography(
                    '• Puedes tener el rol de artista administrador de un negocio',
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
      ],
    );
  }
}
