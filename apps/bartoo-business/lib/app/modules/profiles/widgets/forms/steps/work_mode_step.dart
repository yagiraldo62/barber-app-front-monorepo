import 'package:bartoo/app/modules/profiles/controllers/forms/profile_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/form/animated_form_step.dart';

class WorkModeStep extends StatelessWidget {
  final ProfileFormController controller;

  const WorkModeStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedFormStep(
      title: '¿Cómo prefieres trabajar?',
      descriptionText: 'Selecciona tu modalidad de trabajo preferida',
      scrollToBottom: controller.scrollToBottom,
      noAnimation: !controller.isCreation,
      onAnimationsComplete: controller.onAnimationsComplete,
      content: Obx(
        () => Column(
          children: [
            _WorkModeCard(
              title: 'Artista Independiente',
              description:
                  'Trabajo de forma independiente, gestiono mi propio negocio y agenda',
              icon: Icons.person,
              isSelected: controller.isIndependentArtist.value == true,
              onTap: () => controller.setWorkMode(true),
            ),
            const SizedBox(height: 16),
            _WorkModeCard(
              title: 'Asociado a Organización',
              description:
                  'Trabajo asociado a una o más organizaciones que gestionan la agenda',
              icon: Icons.business,
              isSelected: controller.isIndependentArtist.value == false,
              onTap: () => controller.setWorkMode(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color:
              isSelected
                  ? colorScheme.primary.withOpacity(0.05)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? colorScheme.primary.withOpacity(0.1)
                        : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? colorScheme.primary : null,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
