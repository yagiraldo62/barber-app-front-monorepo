import 'package:flutter/material.dart' hide Typography;
import '../typography/typography.dart';

class UnauthorizedContent extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onRetry;

  const UnauthorizedContent({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.iconColor,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.lock_outline,
                size: 64,
                color: iconColor ?? Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Typography(
                title ?? 'Contenido No Autorizado',
                variation: TypographyVariation.headlineSmall,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Typography(
                message ?? 'No tienes permiso para acceder a este contenido.',
                variation: TypographyVariation.bodyMedium,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Intentar de nuevo'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
