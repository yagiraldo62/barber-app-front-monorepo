import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/layout/simple_centered_layout.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/typography/typography.dart';
import 'package:ui/widgets/feedback/unauthorized_content.dart';
import 'package:bartoo/app/auth/controllers/business_auth_controller.dart';
import 'package:core/modules/auth/widgets/facebook_login_button.dart';
import '../../controllers/invitation_response_controller.dart';

class InvitationDetails extends StatelessWidget {
  final String token;
  final void Function(bool accepted)? onResponded;
  const InvitationDetails({super.key, required this.token, this.onResponded});

  InvitationDetailsController _getController() {
    final tag = 'invitation-response-$token';
    if (Get.isRegistered<InvitationDetailsController>(tag: tag)) {
      final c = Get.find<InvitationDetailsController>(tag: tag);
      // keep callback updated if provided again
      // if (onResponded != null)
      //   c.onResponded?.call; // no-op to keep analyzer calm
      return c;
    }
    return Get.put(
      InvitationDetailsController(token: token, onResponded: onResponded),
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();
    final authController = Get.find<BusinessAuthController>();

    return Obx(() {
      // Si no está autenticado, mostrar botón de login
      if (authController.user.value == null) {
        return SimpleCenteredLayout(
          body: Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Typography(
                    'Acceso Requerido',
                    variation: TypographyVariation.displayMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  Typography(
                    'Para ver esta invitación, debes estar logueado.',
                    variation: TypographyVariation.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FacebookLoginButton(
                    beforeLogin: () => controller.beforeLogin(),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value != null) {
        return SimpleCenteredLayout(
          body: Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 24),
                  Typography(
                    controller.error.value!,
                    variation: TypographyVariation.bodyMedium,
                    color: Theme.of(context).colorScheme.error,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(label: 'Reintentar', onPressed: controller.load),
                ],
              ),
            ),
          ),
        );
      }

      final invitation = controller.invitation.value;

      // Si no hay datos, mostrar error
      if (invitation == null) {
        return SimpleCenteredLayout(
          body: UnauthorizedContent(
            title: 'Invitación No Encontrada',
            message: 'No pudimos encontrar la invitación solicitada.',
            onRetry: controller.load,
          ),
        );
      }

      // Validar si el usuario es válido para esta invitación
      // Verificar si el usuario actual coincide con el destinatario de la invitación
      final invitedPhone = invitation.invitationPhoneNumber;
      final userPhoneField = authController.user.value?.phoneNumber;

      // Si la invitación está vinculada a un teléfono específico y no coincide
      if (invitedPhone != null &&
          userPhoneField != null &&
          userPhoneField != invitedPhone) {
        return SimpleCenteredLayout(
          body: UnauthorizedContent(
            title: 'Invitación No Válida',
            message:
                'Esta invitación no es para tu usuario. Verifica el token e intenta de nuevo.',
            icon: Icons.error_outline,
            onRetry: controller.load,
          ),
        );
      }

      final org = invitation.organization;
      final loc = invitation.location;
      final role = invitation.role;
      final phone = invitation.invitationPhoneNumber;
      final expiresAt = invitation.tokenExpirationDate;

      return SimpleCenteredLayout(
        body: Card(
          elevation: 0,
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Typography(
                  'Invitación de equipo',
                  variation: TypographyVariation.displayLarge,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                if (org != null)
                  Typography(
                    'Organización: ${org.name}',
                    variation: TypographyVariation.bodyMedium,
                  ),
                if (loc != null)
                  Typography(
                    'Ubicación: ${loc.name}',
                    variation: TypographyVariation.bodyMedium,
                  ),
                Typography(
                  'Rol: ${role.name.toUpperCase()}',
                  variation: TypographyVariation.bodyMedium,
                ),
                if (phone != null)
                  Typography(
                    'Teléfono destino: $phone',
                    variation: TypographyVariation.bodyMedium,
                  ),
                if (expiresAt != null)
                  Typography(
                    'Expira: $expiresAt',
                    variation: TypographyVariation.bodyMedium,
                  ),

                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Rechazar',
                          onPressed:
                              controller.isResponding.value
                                  ? null
                                  : () async {
                                    final ok = await controller.respond(false);
                                    if (ok && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Typography(
                                            'Invitación rechazada',
                                            variation:
                                                TypographyVariation.bodyMedium,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'Aceptar',
                          isLoading: controller.isResponding.value,
                          onPressed:
                              controller.isResponding.value
                                  ? null
                                  : () async {
                                    final ok = await controller.respond(true);
                                    if (ok && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Typography(
                                            'Invitación aceptada',
                                            variation:
                                                TypographyVariation.bodyMedium,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          icon: const Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
