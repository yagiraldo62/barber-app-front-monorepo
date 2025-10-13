import 'package:bartoo/app/modules/auth/views/widgets/client_app_link.dart';
import 'package:bartoo/app/routes/app_pages.dart';
import 'package:core/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart' hide Typography;
import 'package:get/get.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/button/toggle_theme.dart';
import 'package:ui/widgets/typography/typography.dart';

/// View shown to regular client users who are in the wrong app (business app instead of client app)
class WrongAppView extends GetView<BaseAuthController> {
  const WrongAppView({super.key});

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
                          ).colorScheme.errorContainer.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.swap_horiz,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Typography(
                        '¡Hola ${controller.user.value?.name ?? ''}!',
                        variation: TypographyVariation.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      const Typography(
                        'Estás en la versión para negocios',
                        variation: TypographyVariation.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Info container
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
                              'Esta aplicación es para profesionales y negocios que ofrecen servicios.',
                              variation: TypographyVariation.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Typography(
                              'Si deseas agendar citas como cliente, necesitas usar nuestra aplicación para clientes.',
                              variation: TypographyVariation.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Client app link
                      const ClientAppLink(),
                      const SizedBox(height: 24),

                      // Or separator
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Typography(
                              'o',
                              variation: TypographyVariation.bodyMedium,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Info for professionals
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.business_center,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            const Typography(
                              '¿Eres un profesional?',
                              variation: TypographyVariation.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Typography(
                              'Si deseas ofrecer tus servicios como profesional o negocio, selecciona tu tipo de cuenta.',
                              variation: TypographyVariation.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              label: 'Seleccionar tipo de cuenta',
                              onPressed: () => Get.toNamed(Routes.INTRO),
                              icon: const Icon(Icons.arrow_forward, size: 20),
                            ),
                          ],
                        ),
                      ),
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
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
