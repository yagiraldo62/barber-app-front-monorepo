import 'package:flutter/material.dart' hide Typography;
import 'package:ui/widgets/typography/typography.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget that displays a link to the client app version
class ClientAppLink extends StatelessWidget {
  const ClientAppLink({super.key});

  // TODO: Replace with actual client app URL from environment variables
  static const String clientAppUrl = 'https://bartoo.app/client';

  Future<void> _launchClientApp() async {
    final Uri url = Uri.parse(clientAppUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $clientAppUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Typography(
                '¿Buscas agendar citas?',
                variation: TypographyVariation.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Typography(
            'Si eres cliente y deseas agendar servicios, descarga nuestra aplicación para clientes.',
            variation: TypographyVariation.bodyMedium,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _launchClientApp,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Typography(
                    'Ir a la app de clientes',
                    variation: TypographyVariation.labelLarge,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
