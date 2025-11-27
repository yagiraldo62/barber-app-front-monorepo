import 'package:bartoo/app/auth/views/widgets/client_app_link.dart';
import 'package:core/modules/auth/controllers/base_auth_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/button/toggle_theme.dart';
import 'package:ui/widgets/typography/typography.dart';

/// View shown to collaborator/location member users who don't have an organization assigned yet
class NoOrganizationView extends GetView<BaseAuthController> {
  const NoOrganizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with theme toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const ToggleThemeButton()],
              ),
              const SizedBox(height: 40),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.business_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Typography(
                        '¡Bienvenido ${controller.user.value?.name ?? ''}!',
                        variation: TypographyVariation.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      const Typography(
                        'Aún no tienes una organización asignada',
                        variation: TypographyVariation.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Instructions container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 32,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            const Typography(
                              'Para acceder a esta aplicación, necesitas ser miembro de una organización.',
                              variation: TypographyVariation.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Typography(
                              'Por favor, contacta al administrador de la organización a la que perteneces para que te agregue como colaborador.',
                              variation: TypographyVariation.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Client app link
                      const ClientAppLink(),
                    ],
                  ),
                ),
              ),

              // Logout button
              const SizedBox(height: 24),
              AppButton(
                label: 'Cerrar sesión',
                onPressed: () => controller.signout(),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
