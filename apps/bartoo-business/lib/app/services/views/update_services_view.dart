import 'package:bartoo/app/services/controllers/update_services_controller.dart';
import 'package:bartoo/app/services/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/layout/app_layout.dart';
import 'package:ui/widgets/button/app_button.dart';
import 'package:ui/widgets/typing_text/secuential_typing_messages.dart';
import 'package:ui/widgets/typography/typography.dart';

class UpdateServicesView extends GetView<UpdateServicesController> {
  const UpdateServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final showServicesContent = (!controller.isCreation).obs;
    final welcomeKey = GlobalKey<SequentialTypingMessagesState>();

    return AppLayout(
      title: 'Servicios de ubicación',
      back: true,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Si está cargando, muestra el indicador de progreso
              if (controller.isLoading.value ||
                  controller.isCategoriesLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchLocationServices(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.categoriesErrorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.categoriesErrorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchCategories(),
                        child: const Text('Reintentar carga de categorías'),
                      ),
                    ],
                  ),
                );
              }

              // Ahora todo el contenido estará dentro de un ListView
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Mostrar la animación de typing si estamos en modo creación
                  if (controller.isCreation)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SequentialTypingMessages(
                        key: welcomeKey,
                        onComplete: () => showServicesContent.value = true,
                        startImmediately: true,
                        messages: const [
                          SequentialTypingMessagesItem(
                            text: 'Configura los servicios para esta ubicación',
                            variation: TypographyVariation.titleLarge,
                            duration: Duration(milliseconds: 800),
                            spacingAfter: 24.0,
                          ),
                          SequentialTypingMessagesItem(
                            text:
                                'Añade todos los servicios que ofreces en esta ubicación',
                            duration: Duration(milliseconds: 800),
                          ),
                          SequentialTypingMessagesItem(
                            text:
                                'Tus clientes podrán ver y reservar estos servicios en la aplicación',
                            duration: Duration(milliseconds: 1000),
                            spacingAfter: 24.0,
                          ),
                          SequentialTypingMessagesItem(
                            text:
                                'Puedes organizar tus servicios por categoría y personalizar cada uno...',
                            duration: Duration(milliseconds: 1200),
                            spacingAfter: 32.0,
                          ),
                        ],
                      ),
                    ),

                  // Siempre mostrar los servicios (ya no depende de showServicesContent)
                  AnimatedServicesWidget(
                    controller: controller,
                    isVisible: showServicesContent.value,
                  ),
                ],
              );
            }),
          ),
          // Botón fijo en la parte inferior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: AppButton(
              label: 'Guardar servicios',
              onPressed: () async {
                // Llamar al controlador para guardar todos los cambios
                final success = await controller.saveAllChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Todos los cambios guardados correctamente'
                          : 'Error al guardar los cambios',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              width: double.infinity,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Nuevo widget para mostrar los servicios con animación
class AnimatedServicesWidget extends StatelessWidget {
  final UpdateServicesController controller;
  final bool isVisible;

  const AnimatedServicesWidget({
    super.key,
    required this.controller,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isVisible ? 1.0 : 0.0,
      curve: Curves.easeInOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 800),
        offset: isVisible ? Offset.zero : const Offset(0, 0.1),
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _buildServicesList(),
        ),
      ),
    );
  }

  // Método para construir la lista de servicios
  Widget _buildServicesList() {
    if (controller.locationServices.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No hay servicios disponibles para esta ubicación'),
        ),
      );
    }

    // Agrupar servicios por categoría
    final servicesByCategory = controller.getServicesByCategory();
    final categoryIds = servicesByCategory.keys.toList();
    final List<Widget> categoryWidgets = [];

    for (var categoryId in categoryIds) {
      final services = servicesByCategory[categoryId]!;
      final categoryName = controller.getCategoryName(categoryId);

      categoryWidgets.addAll([
        // Encabezado de categoría con título y botón de añadir
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Botón para añadir nuevo servicio en esta categoría
            TextButton.icon(
              onPressed: () {
                controller.addNewService(categoryId);
              },
              icon: Icon(
                Icons.add_circle,
                color: Get.context!.theme.colorScheme.primary,
              ),
              label: Text(
                'Nuevo servicio',
                style: TextStyle(color: Get.context!.theme.colorScheme.primary),
              ),
            ),
          ],
        ),
        // Divider para separar el título de los servicios
        const Divider(thickness: 2),
        // Lista de servicios en esta categoría
        ...services.map(
          (service) => ServiceCard(service: service, controller: controller),
        ),
        const SizedBox(height: 24), // Espacio entre categorías
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryWidgets,
    );
  }
}
