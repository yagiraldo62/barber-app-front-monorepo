import 'package:ui/widgets/horizontal_introduction/controllers/typewriter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypewriterText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration startDelay;
  final TextAlign textAlign;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.startDelay = const Duration(milliseconds: 500),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    // Creamos un ID único basado en el texto para el controlador
    final String controllerId = 'typewriter_${text.hashCode}';

    // Obtenemos o creamos el controlador
    final TypewriterController controller = Get.put(
      TypewriterController(
        fullText: text,
        duration: duration,
        startDelay: startDelay,
      ),
      tag: controllerId,
    );

    // Usamos Obx para observar cambios en el texto visible
    return Obx(
      () => Text(
        controller.visibleText.value,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
